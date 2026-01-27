<!doctype html>
<html lang="tr">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>Türkçe Dili ve Grameri</title>
  <style>
    body{font-family:Arial,sans-serif;margin:0;background:#0b1220;color:#e5e7eb}
    header{padding:40px 20px;text-align:center;background:rgba(0,0,0,.4)}
    main{max-width:900px;margin:0 auto;padding:30px 20px}
    .card{background:rgba(255,255,255,.06);padding:18px;border-radius:14px;margin:14px 0}
    a{color:#93c5fd}
  </style>
</head>
<body>
  <header>
    <h1>Türkçe Dili ve Grameri</h1>
    <p>Dersler, örnekler ve alıştırmalar.</p>
  </header>

  <main>
    <div class="card">
      <h2>Dersler</h2>
      <p>Burada Türkçe dilbilgisi dersleri ve materyaller yer alacaktır.</p>
    </div>

    <div class="card">
      <h2>İletişim</h2>
      <p>Email: 
        <a href="mailto:makadjokic12@gmail.com">makadjokic12@gmail.com</a>
      </p>
    </div>
  </main>
</body>
</html>

<style>
  /* ... tvoj postojeći CSS ... */

  .notebook-wrap{
    display:flex;
    gap:22px;
    align-items:stretch;
    flex-wrap:wrap;
  }

  .notebook{
    flex:1 1 380px;
    border-radius:16px;
    padding:22px 22px 22px 34px;
    position:relative;
    background:
      /* plave linije */
      repeating-linear-gradient(
        to bottom,
        rgba(59,130,246,0.18) 0px,
        rgba(59,130,246,0.18) 1px,
        rgba(255,255,255,0) 1px,
        rgba(255,255,255,0) 28px
      ),
      /* papir */
      rgba(255,255,255,0.06);
    box-shadow: 0 10px 30px rgba(0,0,0,0.25);
  }

  /* crvena margina levo kao sveska */
  .notebook::before{
    content:"";
    position:absolute;
    left:16px;
    top:14px;
    bottom:14px;
    width:2px;
    background: rgba(239,68,68,0.55);
    border-radius:2px;
  }

  .notebook h2{
    margin:0 0 10px 0;
    font-size:20px;
    letter-spacing:0.2px;
  }

  .notebook p{
    margin:10px 0;
    line-height:1.7;
  }

  .notebook ul{
    margin:10px 0 10px 18px;
    padding:0;
    line-height:1.7;
  }

  .notebook li{
    margin:8px 0;
  }

  .muted{
    opacity:0.9;
  }
</style>
