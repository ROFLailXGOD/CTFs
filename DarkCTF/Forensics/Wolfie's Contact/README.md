# Wolfie's Contact (221 points, 246 solves)

> Wolfie is doing some illegal work with his friends find his contacts.

К заданию также прикреплён архив [wolfie_evidence.rar](./wolfie_evidence.rar), в котором лежит образ 
`wolfie_evidence.E01`. Я не стал его монтировать и просто попытался найти флаг в строках:

```shell script
$ strings wolfie_evidence.E01 | grep "darkCTF{"
	<c:Notes>darkCTF{</c:Notes><c:CreationDate>2020-09-20T18:18:41Z</c:CreationDate><c:Extended xsi:nil="true"/>
``` 

Хм, строка нашлась, но это лишь часть флага. Интересно, что она заключена в `<c:Notes>`. Попробуем поискать другие
подобные блоки:

```shell script
$ strings wolfie_evidence.E01 | grep "Notes"
...
	<c:Notes>All HAil Wolfiee!!!</c:Notes><c:CreationDate>2020-09-20T18:17:25Z</c:CreationDate><c:Extended xsi:nil="true"/>
	<c:Notes>darkCTF{</c:Notes><c:CreationDate>2020-09-20T18:18:41Z</c:CreationDate><c:Extended xsi:nil="true"/>
	<c:Notes c:Version="1" c:ModificationDate="2020-09-20T18:19:52Z">C0ntacts_
</c:Notes><c:CreationDate>2020-09-20T18:19:12Z</c:CreationDate><c:Extended xsi:nil="true"/>
	<c:Notes>4re_
</c:Notes><c:CreationDate>2020-09-20T18:19:55Z</c:CreationDate><c:Extended xsi:nil="true"/>
	<c:Notes>1mp0rtant}</c:Notes><c:CreationDate>2020-09-20T18:21:20Z</c:CreationDate><c:Extended xsi:nil="true"/>
```

А вот и остальные части! Главное не пропустить строку `C0ntacts_`, которая находится в правой части на третьей строке.