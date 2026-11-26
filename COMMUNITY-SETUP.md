# Aktivacija Joker FX zajednice
Ova verzija ne koristi stvarnu bazu dok se ne unesu podaci projekta. Svi članovi, postovi, komentari i chat bit će zajednički tek nakon aktivacije.
1. Kreiraj novi Supabase projekt u EU regiji.
2. Pokreni community-schema.sql jednom u SQL Editoru novog projekta.
3. U Authentication postavi Site URL na konačni HTTPS domen i dozvoljene redirect URL-ove. Zadrži potvrdu e-maila; podesi vlastiti SMTP, CAPTCHA i ograničenja registracije prije javnog otvaranja.
4. U community-config.js unesi Project URL i isključivo publishable ili legacy anon ključ. Nikada service_role, sb_secret ili lozinku baze. Objavi preko vlastitog domena; nemoj koristiti testni proxy za stvarne korisničke naloge.
5. Testiraj s dva odvojena računa: registracija, potvrda, profil, objava, odgovor, chat, odjava, brisanje vlastite objave. Provjeri da anonimni korisnik nema pristup tabelama i da korisnik ne može pisati kao drugi korisnik.
6. Prije javne registracije dodaj moderiranje, prijave zloupotrebe, ograničenja slanja poruka na serveru, brisanje računa, politiku privatnosti i uvjete korištenja. Trenutna verzija nema te funkcije, privatne poruke, video sastanke ni administrativni panel. 
Napomena: Prikazana imena su nadimci, ne verificirani identiteti. Podaci o članovima vidljivi su samo prijavljenim korisnicima, email nije u tabeli profila. SQL i frontend nisu testirani na stvarnoj Supabase instanci.
