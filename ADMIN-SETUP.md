# Joker FX: administracija (V15)
1. Aktivirati community-schema.sql u novom Supabase projektu, zatim admin-schema.sql.
2. Kreirati i potvrditi vlastiti korisnički račun (Authentication > Users). Vlasnik projekta ručno upisuje njegov točan Auth UUID u jf_admins preko SQL editora. Ne dodavati javnu funkciju za dodjelu uloga. 
3. Postaviti public URL i publishable/anon ključ u community-config.js; nikada secret/service_role ključ. Koristiti odobreni HTTPS domen, ne testne proxyje. Admin stranica nije u javnoj navigaciji; zaštita je RLS, ne tajnost URL-a.
4. Provjeriti s običnim računom i admin računom: običan račun ne može čitati nacrte, dodijeliti ulogu, mijenjati sadržaj, blokirati članove ili brisati tuđe objave. Anoniman korisnik može čitati isključivo objavljene autorske tekstove. Testirati zabranu pisanja, ponovno dopuštanje, brisanje i javni prikaz objava.
5. Za webinare upisati termin i javnu HTTPS poveznicu. Video sastanci se održavaju preko vanjske usluge; integrirani video i privatne pozivnice nisu implementirani.
6. Prije javnog otvaranja: obavezna provjera RLS-a na stvarnoj instanci, CAPTCHA/SMTP, ograničavanje spama i prijave zloupotrebe, politika privatnosti, uvjeti korištenja, postupak brisanja računa i sigurnosne kopije. Nisu uključeni analitika posjeta, potpuni CMS za postojeće lekcije, upravljanje vanjskim RSS izvorima ni privatne poruke.
7. Admin prikazuje do 200 posljednjih članova i sadržaja te do 100 posljednjih stavki po tipu moderiranja; brojači koriste stvarni count iz baze.
