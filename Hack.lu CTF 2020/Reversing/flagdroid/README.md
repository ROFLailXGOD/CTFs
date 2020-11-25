# flagdroid (153 points, 147 solves)

> This app won't let me in without a secret message. Can you do me a favor and find out what it is? 

К заданию прикреплён файл [flagdroid.apk](./flagdroid.apk), что намекает на то, что мы имеем дело с приложением для
Android. Я с ними никогда не сталкивался, но сложность была заявлена низкая, так что я решил рискнуть. Немного
погуглив, я выяснил, что открыть его можно через [jadx](https://github.com/skylot/jadx).

Во вкладке `Resources` находится файл `AndroidManifest.xml`, из содержания которого можно определить первую
исполняемую функцию:

```xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android" android:versionCode="1" android:versionName="1.0" android:compileSdkVersion="30" android:compileSdkVersionCodename="11" package="lu.hack.Flagdroid" platformBuildVersionCode="30" platformBuildVersionName="11">
    <uses-sdk android:minSdkVersion="19" android:targetSdkVersion="30"/>
    <application android:theme="@style/AppTheme" android:label="@string/app_name" android:icon="@mipmap/ic_launcher" android:allowBackup="true" android:supportsRtl="true" android:roundIcon="@mipmap/ic_launcher_round" android:appComponentFactory="androidx.core.app.CoreComponentFactory">
        <activity android:name="lu.hack.Flagdroid.MainActivity">
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>
    </application>
</manifest>
```

Нас интересует строка: 

```xml
<activity android:name="lu.hack.Flagdroid.MainActivity">
```

Значит входной функцией является `lu.hack.Flagdroid.MainActivity`. Файл довольно большой, поэтому буду приводить
лишь основные части. Первое, что бросается в глаза:

```java
String[] split = matcher.group().replace("flag{", "").replace("}", "").split("_");
if (split.length == 4) {
    boolean access$000 = MainActivity.this.checkSplit1(split[0]);
    boolean access$100 = MainActivity.this.checkSplit2(split[1]);
    boolean access$200 = MainActivity.this.checkSplit3(split[2]);
    boolean access$300 = MainActivity.this.checkSplit4(split[3]);
    if (access$000 && access$100 && access$200 && access$300) {
        textView.setVisibility(4);
        textView2.setVisibility(0);
        return;
    }
}
```

Так, из флага убираются `flag{` и `}`, а затем происходит деление через символ `_`. В итоге получается 4 куска,
каждый из которых передаётся в свою функцию `checkSplit[1-4]`. Т.е. задание заключается в восстановлении каждой из
частей. Ну что же, приступим.

### Часть 1

```java 
public boolean checkSplit1(String str) {
    try {
        return new String(Base64.decode(getResources().getString(R.string.encoded), 0), "UTF-8").equals(str);
    } catch (UnsupportedEncodingException unused) {
        return false;
    }
}
```

Хм, берётся некая строка `R.string.encoded`, декодируется из base64 и сравнивается с первой частью флага. Проверим,
что же это за строка. В файле `R.string` находим строку:

```java 
public static final int encoded = 2131492894;
```

Получили какое-то число, но что же оно значит? Из [разбора](https://medium.com/bugbountywriteup/android-ctf-kgb-messenger-d9069f4cedf8)
подобного CTF задания узнаём, что перед нам числовое представление значения строки из файла `strings.xml`. Так,
подождите, что за файл? У нас его нет.

Чуть выше в том же разборе показано использование [apktool](https://ibotpeaches.github.io/Apktool/) для декодирования
`.apk` файлов. Что же, повторим процесс:

```shell script
$ apktool d flagdroid.apk -f -o flagdroid
```

Теперь у нас есть тот самый файл:

```
flagdroid/res/values/strings.xml
```

Продолжаем с момента, где остановились. Опять же из того разбора узнаём, что число надо перевести в 16-ричную систему:
2131492894<sub>10</sub>=7f0c001e<sub>16</sub>. Теперь ищем это значение:

```shell script
$ cat res/values/*.xml | grep "7f0c001e"
<public type="string" name="encoded" id="0x7f0c001e" />
```

Отсюда узнаём имя строки - `encoded`. Эмм, вообще-то мы его уже знали, ну да ладно. Лишний раз убедились, что подходов
может быть несколько и не факт, что в будущем мы так же будем знать название изначально. Давайте же определим значение
этой переменной:

```shell script
$ cat res/values/strings.xml | grep "encoded" 
<string name="encoded">dEg0VA==</string>
$ echo "dEg0VA==" | base64 -d
tH4T
```

Первая часть флага у нас, но это только начало...

### Часть 2

```java 
public boolean checkSplit2(String str) {
    try {
        char[] charArray = str.toCharArray();
        byte[] bytes = "hack.lu20".getBytes("UTF-8");
        if (charArray.length != 9) {
            return false;
        }
        for (int i = 0; i < 9; i++) {
            charArray[i] = (char) (charArray[i] + i);
            charArray[i] = (char) (charArray[i] ^ bytes[i]);
        }
        return String.valueOf(charArray).equals("\u001fTT:\u001f5ñHG");
    } catch (UnsupportedEncodingException unused) {
        return false;
    }
}
```

По коду сразу замечаем, что длина второй части равна 9-ти символам и имеется массив `bytes`. основанный на строке 
`hack.lu20`. Далее в цикле по всем символам с ними производятся несложные математические действия, и результат 
сравнивается со строкой `\u001fTT:\u001f5ñHG`. Я поначалу не понял, откуда такая длина, но чуть более детальный осмотр 
указал на то, что это различные Юникод символы и не все из них являются печатными. Например, `\u001f` - это 
[разделитель полей](https://unicode-table.com/ru/001F/).

Ревёрсить это вручную мне было лень, поэтому я написал небольшой Python 3 скрипт:

```python
hack = "hack.lu20"
out = [0x1F, 0x54, 0x54, 0x3A, 0x1F, 0x35, 0xF1, 0x48, 0x47]   
flag = ''      
for i in range(8, -1, -1):
    ch = out[i] ^ ord(hack[i])
    ch -= i
    flag += chr(ch)
print(flag[::-1])
```

Здесь `out` - это 16-ричное представление каждого из символов выходной строки `\u001fTT:\u001f5ñHG`. Запуск скрипта
даёт нам вторую часть флага: `w45N-T~so`.

### Часть 3

```java 
public boolean checkSplit3(String str) {
    String lowerCase = str.toLowerCase();
    if (lowerCase.length() == 8 && lowerCase.substring(0, 4).equals("h4rd")) {
        return md5(lowerCase).equals("6d90ca30c5de200fe9f671abb2dd704e");
    }
    return false;
}
```

Из этого небольшого куска можно узнать много полезного. Во-первых, строка приводится к нижнему регистру. Во-вторых, её
длина составляет 8 символов. В-третьих, она начинается с `h4rd`. И наконец, её `md5` хеш равен 
`6d90ca30c5de200fe9f671abb2dd704e`.

Окей, а как найти вторую половину? Первым делом я попытался найти этот хеш на [CrackStation.net](https://crackstation.net/),
но безуспешно. И тут я догадался - нам нужно найти лишь 4 символа. При этом они могут буквами (к тому же только в нижнем
регистре), цифрами и символами типа `-` или `~`. Давайте забрутфорсим! Очередной скрипт на Python 3:

```python
import hashlib
md5 = '6d90ca30c5de200fe9f671abb2dd704e'
flag = b'h4rd'
symbols = b'qwertyuiopasdfghjklzxcvbnm1234567890-~'
for ch1 in symbols:
    for ch2 in symbols:
        for ch3 in symbols:
            for ch4 in symbols:
                test = flag + ch1.to_bytes(1, 'big') + ch2.to_bytes(1, 'big') + ch3.to_bytes(1, 'big') + ch4.to_bytes(1, 'big')
                hash2 = hashlib.md5(test)
                if hash2.hexdigest() == md5:
                    print(test)
``` 

Не самая красивая реализация, но, хей, она работает! Третья часть флага - `h4rd~huh`.

### Часть 4

```java 
    public boolean checkSplit4(String str) {
        return str.equals(stringFromJNI());
    }
```

Вот тут я застрял на какое-то время. Никак не мог найти информации по `stringFromJNI()`, однако всё же наткнулся на
[статью](https://mobile-security.gitbook.io/mobile-security-testing-guide/android-testing-guide/0x05c-reverse-engineering-and-tampering).
Из неё узнаём следующее:

```
Note the declaration of public native String stringFromJNI at the bottom. The keyword "native" tells the Java compiler 
that this method is implemented in a native language. The corresponding function is resolved during runtime, but only 
if a native library that exports a global symbol with the expected signature is loaded (signatures comprise a package 
name, class name, and method name). In this example, this requirement is satisfied by the following C or C++ function:
```

Ага, значит нам нужно искать эту функцию в нативной библиотеке. Если вернуться к декомпиляции через apktool, то можно
обнаружить `lib` директорию, в которой находится ещё 4: `arm64-v8a`, `armeabi-v7a`, `x86` и `x86_64`. В каждой из них
находится библиотека `libnative-lib.so`. Содержание не должно отличаться, ибо по сути там хранится один и и тот же код, 
но скомпилированный под разные архитектуры.

Первым делом я прошёлся `strings` по ним:

```shell script
$ strings lib/x86_64/libnative-lib.so
...
libdl.so
@	?8)
0r~w4S-1H
;*3$"
...
```

Тут явно видна финальная часть флага! Но вот эта буква `H` на конце мне не давала покоя - не должна там быть буква `T`?
Я пробовал подставить и `t`, и `T`, и оставить всё как есть - флаг не проходил. Тогда я решил открыть файл в Ghidra:

```c 
void Java_lu_hack_Flagdroid_MainActivity_stringFromJNI(int *param_1)

{
  undefined4 *puVar1;
  
  puVar1 = (undefined4 *)malloc(0xd);
  *(undefined *)(puVar1 + 2) = 0x74;
  *(undefined4 *)((int)puVar1 + 9) = 0x29383f;
  puVar1[1] = 0x312d5334;
  *puVar1 = 0x777e7230;
  (**(code **)(*param_1 + 0x29c))(param_1,puVar1);
  return;
}
```

Первым делом в глаза бросается то, что в `malloc` передаётся `0xd`, т.е. 13, что наталкивает на мысль, что длина строки
равна 12 (последний байт идёт на [нулл-байт](https://en.wikipedia.org/wiki/Null_character)). Это уже не сходится с
нашей строкой `0r~w4S-1H`. Что же, ничего не остаётся. Давайте попробуем разобраться со значениями. На самом деле
значения действительно интересные, ибо они похожи на 16-ричное представление ASCII символов.

```
0x74: t
0x29383f: )8?
0x312d5334: 1-S4
0x777e7230: w~r0
```

Так, длина как раз таки стала равна 12-ти, но сами символы выглядят бессмысленно, хоть они и похожи на то, что мы
получили через `strings`. Подождите, а если их переписать в обратном порядке? Получаем:

```
0r~w
4S-1
?8)
t
```

Так, уже близко, но третью и четвёртую строку надо поменять местами. До этого можно догадаться даже без исследования
кода, хотя и там несложно.

Наконец, собираем наш флаг (не забываем вернуть убранные символы):

```
flag{tH4T_w45N-T~so_h4rd~huh_0r~w4S-1t?8)}
```

Действительно, было не очень сложно, но очень интересно!
