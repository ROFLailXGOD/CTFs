# Leggos (100 points, 898 solves)

> I <3 Pasta! I won't tell you what my special secret sauce is though!
>
> https://chal.duc.tf:30101

Переходим по ссылке, и нам открывается простенькая страничка с изображением банки соуса. Очевидно, что
"Sauce" — это отсылка к "Source", поэтому я попытался открыть его через привычное `ПКМ->View Page Source`, но меня
ждал сюрприз:

![](https://i.imgur.com/vEMzkF7.png)

Что же, не проблема, я могу и F12 нажать. `(index)` не содержит флага, но в нём есть хинт:

```html
<div class="main-body">
    <h1>My Second Favourite Pasta Sauce</h1>
    <p>This is my second favourite pasta sauce! I have safely hidden my favourite sauce!</p>
    <!-- almost there -->
    <img src="./sauce.JPEG" >
</div>
```

`disableMouseRightClick.js` оказался куда более полезным:

```js
document.addEventListener('contextmenu', function(e) {
    e.preventDefault();
    alert('not allowed');
});

  //the source reveals my favourite secret sauce 
  // DUCTF{n0_k37chup_ju57_54uc3_r4w_54uc3_9873984579843} 
```

Забираем флаг.
