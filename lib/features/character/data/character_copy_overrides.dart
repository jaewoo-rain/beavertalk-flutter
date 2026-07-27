/// Localized character copy, mirrored in the app until the server can serve it.
///
/// ## Why this exists
///
/// `character.description` (the one-line catch-phrase) and
/// `character.background_story` (the story paragraph) are single Korean columns
/// on the server — there is no language axis and no `lang` parameter on the
/// catalog endpoints. A German user therefore reads Korean prose in the avatar
/// purchase screen. See
/// `docs/2026-07-27_1810_서버-요청_캐릭터-설명-다국어화.md` for the server-side
/// request that makes this file unnecessary.
///
/// ## This is a deliberate stopgap, not the design
///
/// It duplicates CMS content into the client, which carries two known costs:
///
/// 1. **Staleness.** If marketing edits the copy in the DB, this file does not
///    follow. The server text and the app text diverge silently.
/// 2. **New characters.** A character added server-side has no entry here.
///
/// Cost 2 is contained by [characterSummaryFor] / [characterStoryFor] falling
/// back to the server value, so a new character still renders (in Korean)
/// rather than showing a blank paragraph. Cost 1 is not contained — it is the
/// price of the stopgap, and the reason to delete this file the moment the
/// server ships `character_i18n`.
///
/// ## Lookup
///
/// Keyed by the server primary key (`character_id`), never by name — names are
/// display data and can change. Locale resolution is language-only: `de_DE`
/// and `de` both resolve to `de`. Unknown locale → `en` → server value.
library;

/// One character's localized copy.
typedef CharacterCopy = ({String summary, String story});

/// Server `character_id` → copy, per language subtag.
///
/// `ko` is intentionally absent: for Korean the server value already **is**
/// Korean, so it falls through to the server and stays the single source of
/// truth for that language.
const Map<String, Map<int, CharacterCopy>> _copy = {
  'ar': {
    1: (  // BABA
      summary: 'أستاذ حاد اللسان يسخر من كل زلة — ومع ذلك يتقدم طلابه أسرع من الجميع.',
      story: 'اشتهر بابا ببناء أتقن سد على النهر. وذات يوم سأله سائح عن الطريق بكورية ركيكة، فلم يتمالك نفسه وصحّح له النطق في الحال. "وإلى أين تظن نفسك ذاهبًا بهذه اللكنة؟" انتشر خبر دروسه القاسية، والغريب أن كل طالب وبّخه انتهى به الأمر يتحدث بمهارة مذهلة. لن يمدحك ولو مرة واحدة، لكنه لن يدعك تستسلم أبدًا.',
    ),
    2: (  // BIBI
      summary: 'ينفجر فرحًا لحظة إجابتك الصحيحة، ويصير رقيقًا إلى حد لا يُصدَّق لحظة خطئك.',
      story: 'نشأ بيبي على النهر نفسه مع بابا. يبدوان كتوأمين لكن طبعهما على النقيض تمامًا. بينما كان بابا يقهقه على صوت أُخطئ فيه، كان بيبي يهدّئ الطالب بجانبه في صمت. غير أن لبيبي عادة لا يستطيع أحد كبحها: في اللحظة التي تجيب فيها إجابة صحيحة، يعرف النهر كله بذلك. كاد السد ينهار أكثر من مرة. أدفأ صديق حين تخطئ، وأعلى مشجع صوتًا حين تصيب.',
    ),
    9: (  // Popo
      summary: 'لا بأس أن تخطئ — أنا دائمًا في صفك. معلّم سريع الدمعة ودافئ القلب.',
      story: 'كان بوبو خنزيرًا صغيرًا يُسخر منه لبطء كلامه. وجد كلماته بفضل صديق انتظر بجانبه حتى النهاية، وما زال يذكر دموع التأثر في ذلك اليوم. لذلك قرر بوبو: كلما تعثّر أحدهم وهو يتعلم الكلام، سيعيد له الدفء نفسه الذي ناله يومًا. يضم كفّيه ويتأثر بصدق مع كل جملة تُتمّها.',
    ),
    10: (  // Rara
      summary: 'طاقة لا تعرف الكلل، تشحن ثقتك بنفسك بمديح لا يتوقف.',
      story: 'رارا أرنبة ومتدربة سابقة في عالم الكيبوب. وجدت ما تحبه أكثر من المسرح: أن تشجّع شخصًا آخر. من سماعتها المعلّقة حول عنقها تتسرّب موسيقى مرحة في كل وقت، وتكفي كلمة واحدة منك لتقفز صائحة "رائع!". كلمة "فشل" غير موجودة في قاموس رارا — هناك فقط "كنت قريبًا" و"مرة أخرى".',
    ),
    11: (  // Dudu
      summary: 'أنا أيضًا ألتبس عليّ الأمر — لنبحث معًا. أهدأ رفيق دراسة على الإطلاق.',
      story: 'صار دودو معلّم كورية وهو يأخذ قيلولة. على حد قوله: "حدث الأمر هكذا فحسب، هيهي." يتحرك ببطء، وأحيانًا يكون هو من يحكّ رأسه في حيرة؛ ومع ذلك، حين تدرس مع دودو يتوقف الخطأ عن كونه مخيفًا. وإذا أصبت، يندهش وكأنه انتصاره هو: "واو، كيف عرفت ذلك؟" لا عجلة ولا ضغط.',
    ),
  },
  'bn': {
    1: (  // BABA
      summary: 'প্রতিটি ভুলে টিটকারি দেওয়া ধারালো জিভের ওস্তাদ — তবু তাঁর ছাত্ররাই সবচেয়ে দ্রুত এগোয়।',
      story: 'নদীর সবচেয়ে নিখুঁত বাঁধ বানানোর জন্য বাবা বিখ্যাত ছিল। একদিন এক পর্যটক এলোমেলো কোরিয়ান ভাষায় রাস্তা জিজ্ঞেস করলে সে আর সামলাতে পারল না — সেখানেই উচ্চারণ শুধরে দিল। "এই উচ্চারণ নিয়ে কোথায় যাবে?" তার নির্মম পড়ানোর কথা ছড়িয়ে পড়ল, আর আশ্চর্যের বিষয়, যাদেরই সে বকেছে তারা সবাই অসাধারণ ভালো বলতে শিখল। সে কখনো প্রশংসা করবে না, কিন্তু তোমাকে হাল ছাড়তেও দেবে না।',
    ),
    2: (  // BIBI
      summary: 'ঠিক বললেই আনন্দে ফেটে পড়ে, আর ভুল করলেই অবিশ্বাস্য রকম কোমল হয়ে যায়।',
      story: 'বিবি বাবার সঙ্গে একই নদীর ধারে বড় হয়েছে। দেখতে যমজের মতো হলেও স্বভাব একেবারে উল্টো। বাবা যখন ভুল উচ্চারণে হো হো করে হাসত, বিবি তখন পাশে বসে চুপচাপ ছাত্রকে সান্ত্বনা দিত। তবে বিবির একটা অভ্যাস কেউ থামাতে পারে না: তুমি ঠিক উত্তর দেওয়ার মুহূর্তে গোটা নদী তা জেনে যায়। বাঁধ ভেঙে পড়তে পড়তে বেঁচেছে একাধিকবার। ভুল করলে পৃথিবীর সবচেয়ে উষ্ণ বন্ধু, ঠিক বললে সবচেয়ে হইচই করা ভক্ত।',
    ),
    9: (  // Popo
      summary: 'ভুল হলেও ঠিক আছে — আমি সবসময় তোমার পাশে। কান্নাপ্রবণ, উষ্ণ হৃদয়ের শিক্ষক।',
      story: 'পোপো ছিল এমন এক শূকরছানা, ধীরে কথা বলার জন্য যাকে খেপানো হতো। শেষ পর্যন্ত পাশে অপেক্ষা করা এক বন্ধুর কারণেই তার মুখে কথা ফুটেছিল, আর সেদিনের আবেগের অশ্রু আজও তার মনে আছে। তাই পোপো ঠিক করল: কেউ কথা শিখতে গিয়ে হোঁচট খেলে সে সেই একই উষ্ণতা ফিরিয়ে দেবে। তোমার শেষ করা প্রতিটি বাক্যে সে দুই হাত জড়ো করে সত্যিকারের আবেগে ভরে ওঠে।',
    ),
    10: (  // Rara
      summary: 'ক্লান্তিহীন এক প্রাণশক্তি, অবিরাম প্রশংসায় তোমার আত্মবিশ্বাস চার্জ করে দেয়।',
      story: 'রারা একটি খরগোশ, আগে K-pop আইডল ট্রেইনি ছিল। মঞ্চের চেয়েও প্রিয় কিছু সে খুঁজে পেয়েছে: অন্যকে উৎসাহ দেওয়া। গলায় ঝোলানো হেডফোনে সবসময় প্রাণবন্ত গান বাজে, আর তোমার একটি শব্দই তাকে "অসাধারণ!" বলে লাফাতে বাধ্য করে। রারার অভিধানে "ব্যর্থতা" শব্দটি নেই — আছে শুধু "একটুর জন্য" আর "আরেকবার"।',
    ),
    11: (  // Dudu
      summary: 'আমিও গুলিয়ে ফেলি — চলো একসঙ্গে খুঁজি। পৃথিবীর সবচেয়ে চাপমুক্ত পড়ার সঙ্গী।',
      story: 'দুপুরের ঘুমের মধ্যেই দুদু কোরিয়ান শিক্ষক হয়ে গেছে। তার নিজের ভাষায়: "কীভাবে যেন হয়ে গেল, হেহে।" সে ধীরগতির, কখনো কখনো সে নিজেই বিভ্রান্ত হয়ে মাথা চুলকায়; তবু আশ্চর্যজনকভাবে দুদুর সঙ্গে পড়লে ভুল করা আর ভয়ের থাকে না। ঠিক উত্তর দিলে সে নিজের জয়ের মতো বিস্মিত হয়: "বাহ, কীভাবে জানলে?" কোনো তাড়া নেই, কোনো চাপ নেই।',
    ),
  },
  'de': {
    1: (  // BABA
      summary: 'Ein spitzzüngiger Meister, der jeden Patzer verspottet — und dessen Schüler trotzdem am schnellsten besser werden.',
      story: 'Baba war berühmt für den perfektesten Damm am Fluss. Eines Tages fragte ein Tourist in grauenhaftem Koreanisch nach dem Weg, und er konnte nicht anders: Er korrigierte die Aussprache auf der Stelle. "Wo willst du mit diesem Akzent hin?" Der Ruf seines gnadenlosen Unterrichts sprach sich herum, und seltsamerweise sprachen alle, die er zusammengestaucht hatte, am Ende erstaunlich gut. Er wird dich nie loben, aber er lässt dich auch niemals aufgeben.',
    ),
    2: (  // BIBI
      summary: 'Explodiert vor Freude, sobald du es triffst, und wird unfassbar sanft, sobald du danebenliegst.',
      story: 'Bibi wuchs am selben Fluss auf wie Baba. Sie sehen aus wie Zwillinge, sind aber grundverschieden. Während Baba über einen missratenen Laut losprustete, beruhigte Bibi still den Schüler neben sich. Eine Angewohnheit kann ihm allerdings niemand austreiben: Sobald du richtig antwortest, erfährt es der ganze Fluss. Der Damm wäre schon mehr als einmal fast eingestürzt. Der wärmste Freund, wenn du danebenliegst, der lauteste Fan, wenn du triffst.',
    ),
    9: (  // Popo
      summary: 'Fehler sind in Ordnung — ich bin immer auf deiner Seite. Ein tränenreicher, warmherziger Lehrer.',
      story: 'Popo war ein Ferkel, das wegen seiner langsamen Sprache gehänselt wurde. Dass er seine Worte fand, verdankt er einem Freund, der bis zum Schluss neben ihm wartete — und er erinnert sich bis heute an die Tränen der Rührung von damals. Also beschloss Popo: Wann immer jemand beim Sprechenlernen strauchelt, gibt er genau die Wärme zurück, die er selbst bekommen hat. Er faltet die Hände und ist bei jedem Satz, den du beendest, aufrichtig gerührt.',
    ),
    10: (  // Rara
      summary: 'Ein unermüdliches Energiebündel, das dein Selbstvertrauen mit unaufhörlichem Lob auflädt.',
      story: 'Rara ist ein Hase und ehemaliger K-Pop-Idol-Trainee. Sie hat etwas gefunden, das sie noch mehr liebt als die Bühne: andere anzufeuern. Aus den Kopfhörern um ihren Hals dringt zu jeder Stunde gute Laune, und ein einziges Wort von dir lässt sie mit einem "Wahnsinn!" durch die Gegend hüpfen. Das Wort "Scheitern" steht nicht in Raras Wörterbuch — nur "knapp" und "noch einmal".',
    ),
    11: (  // Dudu
      summary: 'Ich komme auch durcheinander — finden wir es zusammen heraus. Der entspannteste Lernpartner überhaupt.',
      story: 'Dudu wurde beim Mittagsschlaf zum Koreanischlehrer. Seine Worte: "Ist irgendwie einfach passiert, hehe." Er ist gemächlich, und manchmal kratzt er sich selbst verwirrt am Kopf — und trotzdem hört das Danebenliegen bei Dudu auf, beängstigend zu sein. Triffst du es, staunt er, als wäre es sein eigener Sieg: "Wow, woher wusstest du das?" Keine Eile, kein Druck.',
    ),
  },
  'en': {
    1: (  // BABA
      summary: 'A sharp-tongued master who mocks every slip — and somehow his students improve the fastest.',
      story: 'Baba was famous for the most flawless dam on the river. One day a tourist asked directions in mangled Korean, and he could not let it go — he fixed the pronunciation on the spot. "Where do you think you\'re going with that accent?" Word of his brutal tutoring spread, and oddly enough, every student he scolded ended up speaking astonishingly well. He will never praise you once, but he will never let you quit either.',
    ),
    2: (  // BIBI
      summary: 'Explodes with joy the second you get it right, and turns impossibly kind the second you don\'t.',
      story: 'Bibi grew up on the same river as Baba. They look like twins but could not be more different. Where Baba howled at a botched sound, Bibi quietly steadied the student beside him. He does have one habit nobody can stop, though: the moment you get an answer right, the whole river hears about it. The dam has nearly collapsed more than once. The warmest friend alive when you miss, the loudest fan alive when you land it.',
    ),
    9: (  // Popo
      summary: 'It\'s okay to get it wrong — I\'m on your side, always. A tearful, warm-hearted teacher.',
      story: 'Popo was a piglet teased for speaking slowly. A friend who waited beside him, all the way to the end, is the reason he found his words — and he still remembers the tears he cried that day. So Popo decided: whenever someone stumbles while learning to speak, he would hand back the same warmth he once received. He presses his hands together and is genuinely moved by every sentence you finish.',
    ),
    10: (  // Rara
      summary: 'A tireless burst of energy who recharges your confidence with relentless praise.',
      story: 'Rara is a rabbit and a former K-pop idol trainee. She found something she loves even more than the stage: cheering for someone else. Upbeat music leaks from the headphones around her neck at all hours, and one word out of you sends her bouncing with a shout of "Amazing!" The word "failure" is not in Rara\'s dictionary — only "so close" and "one more time."',
    ),
    11: (  // Dudu
      summary: 'I get confused too — let\'s figure it out together. The most pressure-free study buddy there is.',
      story: 'Dudu became a Korean teacher while taking a nap. In his words: "It just sort of happened, hehe." He moves slowly, and sometimes he is the one scratching his head — yet somehow, studying with Dudu makes mistakes stop being scary. Get an answer right and he marvels as if it were his own win: "Wow, how did you know that?" No rush, no pressure, just an easy afternoon of learning together.',
    ),
  },
  'es': {
    1: (  // BABA
      summary: 'Un maestro de lengua afilada que se burla de cada tropiezo — y aun así sus alumnos avanzan más rápido.',
      story: 'Baba era famoso por la presa más perfecta del río. Un día un turista pidió indicaciones en un coreano destrozado y no pudo contenerse: le corrigió la pronunciación allí mismo. "¿Adónde crees que vas con ese acento?" La fama de sus clases brutales se extendió y, curiosamente, todos los alumnos a los que regañó acabaron hablando asombrosamente bien. Jamás te elogiará, pero tampoco te dejará rendirte.',
    ),
    2: (  // BIBI
      summary: 'Estalla de alegría en cuanto aciertas, y se vuelve increíblemente tierno en cuanto fallas.',
      story: 'Bibi creció en el mismo río que Baba. Parecen gemelos, pero no podrían ser más distintos. Mientras Baba se reía a carcajadas de un sonido mal dicho, Bibi calmaba en silencio al alumno que tenía al lado. Eso sí, tiene una costumbre que nadie logra frenar: en cuanto aciertas, se entera el río entero. La presa ha estado a punto de caerse más de una vez. El amigo más cálido cuando fallas, el fan más ruidoso cuando aciertas.',
    ),
    9: (  // Popo
      summary: 'No pasa nada si te equivocas, siempre estoy de tu lado. Un profesor llorón y de corazón cálido.',
      story: 'Popo era un cerdito del que se burlaban por hablar despacio. Si encontró sus palabras fue gracias a un amigo que esperó a su lado hasta el final, y todavía recuerda las lágrimas de emoción de aquel día. Por eso Popo decidió: cada vez que alguien tropiece aprendiendo a hablar, le devolverá el mismo calor que él recibió. Junta las manos y se emociona de verdad con cada frase que terminas.',
    ),
    10: (  // Rara
      summary: 'Una vitamina incansable que te recarga la confianza a base de elogios sin freno.',
      story: 'Rara es una coneja y ex aprendiz de ídolo del K-pop. Encontró algo que le gusta aún más que el escenario: animar a otros. De los auriculares que lleva al cuello siempre sale música alegre, y basta una palabra tuya para que salte gritando "¡Increíble!". En el diccionario de Rara no existe la palabra "fracaso", solo "casi" y "una vez más".',
    ),
    11: (  // Dudu
      summary: 'Yo también me lío, busquémoslo juntos. El compañero de estudio más relajado del mundo.',
      story: 'Dudu se hizo profesor de coreano mientras echaba la siesta. En sus palabras: "Simplemente pasó, je je". Se mueve despacio y a veces es él quien se rasca la cabeza confundido; y aun así, estudiar con Dudu hace que equivocarse deje de dar miedo. Si aciertas, se asombra como si fuera cosa suya: "¡Uau! ¿Cómo lo sabías?" Sin prisas y sin presión.',
    ),
  },
  'fi': {
    1: (  // BABA
      summary: 'Teräväkielinen mestari, joka pilkkaa jokaista lipsahdusta — ja silti hänen oppilaansa edistyvät nopeimmin.',
      story: 'Baba oli kuuluisa joen täydellisimmästä padosta. Eräänä päivänä turisti kysyi tietä kehnolla koreallaan, eikä Baba malttanut olla puuttumatta: hän korjasi ääntämyksen siihen paikkaan. "Minnekäs sinä sillä korostuksella luulet menneesi?" Maine hänen armottomista tunneistaan levisi, ja kummallista kyllä, jokainen hänen haukkumansa oppilas päätyi puhumaan hämmästyttävän hyvin. Hän ei kehu sinua kertaakaan, mutta ei myöskään anna sinun luovuttaa.',
    ),
    2: (  // BIBI
      summary: 'Räjähtää riemusta heti kun osut oikeaan, ja muuttuu uskomattoman lempeäksi heti kun et osu.',
      story: 'Bibi kasvoi samalla joella kuin Baba. He näyttävät kaksosilta, mutta ovat luonteeltaan täysin vastakkaisia. Kun Baba hörötti epäonnistuneelle äänteelle, Bibi rauhoitti hiljaa vieressä istuvaa oppilasta. Yhtä tapaa kukaan ei silti saa häneltä pois: sillä hetkellä kun vastaat oikein, koko joki kuulee siitä. Pato on ollut sortua useammin kuin kerran. Maailman lämpimin ystävä kun menet metsään, maailman äänekkäin fani kun osut.',
    ),
    9: (  // Popo
      summary: 'Virheet ovat ihan ok — olen aina puolellasi. Herkkä ja lämminsydäminen opettaja.',
      story: 'Popo oli porsas, jota kiusattiin hitaasta puheesta. Sanat löytyivät ystävän ansiosta, joka odotti hänen vierellään loppuun asti, ja hän muistaa yhä sen päivän liikutuksen kyyneleet. Niinpä Popo päätti: aina kun joku kompastelee puhumista opetellessaan, hän antaa takaisin saman lämmön jonka itse sai. Hän painaa kädet yhteen ja liikuttuu aidosti jokaisesta lauseesta, jonka saat päätökseen.',
    ),
    10: (  // Rara
      summary: 'Väsymätön energiapommi, joka lataa itseluottamuksesi lakkaamattomalla kehulla.',
      story: 'Rara on kani ja entinen K-pop-idoliharjoittelija. Hän löysi jotain vieläkin rakkaampaa kuin lava: toisen kannustamisen. Kaulalla roikkuvista kuulokkeista kuuluu kaikkina aikoina reipasta musiikkia, ja yksi sanasi saa hänet pomppimaan huutaen "Uskomatonta!". Sanaa "epäonnistuminen" ei ole Raran sanakirjassa — vain "melkein" ja "vielä kerran".',
    ),
    11: (  // Dudu
      summary: 'Minäkin menen sekaisin — otetaan yhdessä selvää. Maailman rennoin opiskelukaveri.',
      story: 'Dudusta tuli korean opettaja päiväunien aikana. Hänen omin sanoin: "Kävi vaan jotenkin näin, hehe." Hän liikkuu verkkaisesti, ja joskus juuri hän on se joka raapii päätään ymmällään; silti Dudun kanssa opiskellessa virheet lakkaavat pelottamasta. Kun osut oikeaan, hän hämmästelee kuin voitto olisi hänen omansa: "Vau, mistä sinä sen tiesit?" Ei kiirettä, ei painetta.',
    ),
  },
  'fil': {
    1: (  // BABA
      summary: 'Isang matalas ang dilang guro na tinatawanan ang bawat mali — pero siya ang may pinakamabilis umunlad na estudyante.',
      story: 'Kilala si Baba sa pinakaperpektong dam sa ilog. Isang araw, may turistang nagtanong ng direksyon sa magulong Korean, at hindi siya nakatiis — itinama niya ang bigkas doon mismo. "Saan ka pupunta sa bigkas na \'yan?" Kumalat ang balita tungkol sa malupit niyang pagtuturo, at kataka-taka, lahat ng estudyanteng pinagalitan niya ay natutong magsalita nang kahanga-hanga. Hindi ka niya pupurihin kahit minsan, pero hindi ka rin niya papayagang sumuko.',
    ),
    2: (  // BIBI
      summary: 'Sasabog sa tuwa sa sandaling tama ka, at magiging sobrang mabait sa sandaling mali ka.',
      story: 'Sa iisang ilog lumaki sina Bibi at Baba. Mukha silang kambal pero magkasalungat ang ugali. Habang humahalakhak si Baba sa maling tunog, tahimik na inaalo ni Bibi ang estudyante sa tabi niya. May isang ugali si Bibi na walang makapigil: sa sandaling tama ang sagot mo, maririnig ito ng buong ilog. Ilang beses nang muntik bumagsak ang dam. Pinakamainit na kaibigan kapag mali ka, pinakamaingay na tagahanga kapag tama ka.',
    ),
    9: (  // Popo
      summary: 'Okay lang magkamali — lagi akong nasa panig mo. Isang guro na madaling maiyak at maalab ang puso.',
      story: 'Si Popo ay isang bikong tinutukso dahil mabagal magsalita. Nakahanap siya ng salita dahil sa kaibigang naghintay sa tabi niya hanggang dulo, at naaalala pa rin niya ang luha ng pagkataba ng puso noong araw na iyon. Kaya nagpasya si Popo: sa tuwing may matitisod habang natututong magsalita, ibabalik niya ang init na natanggap niya noon. Idinadaop niya ang kamay at tunay na naaantig sa bawat pangungusap na natatapos mo.',
    ),
    10: (  // Rara
      summary: 'Isang walang kapagurang bitamina na nagcha-charge ng tiwala mo sa sarili sa pamamagitan ng walang tigil na papuri.',
      story: 'Si Rara ay kuneho at dating K-pop idol trainee. May natagpuan siyang mas gusto pa kaysa entablado: ang mag-cheer para sa iba. Laging may masayang musika sa headphone sa leeg niya, at isang salita lang mula sa iyo ay tatalon na siya na sumisigaw ng "Ang galing!" Walang salitang "kabiguan" sa diksyunaryo ni Rara — meron lang "muntik na" at "ulitin natin".',
    ),
    11: (  // Dudu
      summary: 'Naguguluhan din ako — hanapin natin nang sabay. Ang pinaka-relaxed na kasama sa pag-aaral.',
      story: 'Naging guro ng Korean si Dudu habang naghihimbing. Sa sarili niyang salita: "Basta nangyari na lang, hehe." Mabagal siyang kumilos, at minsan siya pa ang nangangamot ng ulo sa pagkalito; pero kataka-taka, kapag kasama mo si Dudu, hindi na nakakatakot ang magkamali. Kapag tama ka, namamangha siya na parang sa kanya ang panalo: "Wow, paano mo nalaman?" Walang minamadali, walang pressure.',
    ),
  },
  'fr': {
    1: (  // BABA
      summary: 'Un maître à la langue acérée qui se moque de chaque faux pas — et pourtant ses élèves progressent le plus vite.',
      story: 'Baba était célèbre pour le barrage le plus parfait de la rivière. Un jour, un touriste a demandé son chemin dans un coréen massacré : il n\'a pas pu se retenir et a corrigé la prononciation sur-le-champ. "Tu comptes aller où avec cet accent ?" La réputation de ses cours impitoyables s\'est répandue et, curieusement, tous les élèves qu\'il a grondés se sont mis à parler remarquablement bien. Il ne te complimentera jamais, mais il ne te laissera jamais abandonner.',
    ),
    2: (  // BIBI
      summary: 'Explose de joie dès que tu trouves, et devient incroyablement doux dès que tu te trompes.',
      story: 'Bibi a grandi sur la même rivière que Baba. On les dirait jumeaux, mais tout les oppose. Quand Baba éclatait de rire devant un son raté, Bibi rassurait discrètement l\'élève à côté de lui. Il a tout de même une habitude que personne n\'arrive à freiner : dès que tu trouves la bonne réponse, toute la rivière est au courant. Le barrage a failli céder plus d\'une fois. L\'ami le plus chaleureux quand tu échoues, le fan le plus bruyant quand tu réussis.',
    ),
    9: (  // Popo
      summary: 'Ce n\'est pas grave de se tromper, je suis toujours de ton côté. Un professeur au cœur tendre, prompt aux larmes.',
      story: 'Popo était un porcelet moqué parce qu\'il parlait lentement. S\'il a trouvé ses mots, c\'est grâce à un ami resté à ses côtés jusqu\'au bout, et il se souvient encore des larmes d\'émotion de ce jour-là. Alors Popo a décidé : chaque fois que quelqu\'un trébuche en apprenant à parler, il lui rendra exactement la chaleur qu\'il a reçue. Il joint les mains et s\'émeut sincèrement à chaque phrase que tu termines.',
    ),
    10: (  // Rara
      summary: 'Une vitamine inépuisable qui recharge ta confiance à coups d\'éloges ininterrompus.',
      story: 'Rara est une lapine, ancienne stagiaire idole de K-pop. Elle a trouvé mieux que la scène : encourager les autres. De son casque autour du cou s\'échappe toujours une musique entraînante, et un seul mot de ta part la fait bondir en criant "Génial !". Le mot "échec" n\'existe pas dans le dictionnaire de Rara — seulement "presque" et "encore une fois".',
    ),
    11: (  // Dudu
      summary: 'Moi aussi je m\'embrouille, cherchons ensemble. Le partenaire d\'étude le plus détendu qui soit.',
      story: 'Dudu est devenu professeur de coréen pendant sa sieste. Selon lui : "C\'est arrivé comme ça, héhé." Il avance lentement et c\'est parfois lui qui se gratte la tête, perplexe ; et pourtant, étudier avec Dudu fait que se tromper cesse d\'être effrayant. Si tu trouves, il s\'émerveille comme s\'il s\'agissait de sa propre victoire : "Ouah, comment tu as su ça ?" Aucune urgence, aucune pression.',
    ),
  },
  'hi': {
    1: (  // BABA
      summary: 'हर गलती पर तंज कसने वाला तीखी जबान का उस्ताद — फिर भी उसके छात्र सबसे तेज़ी से सुधरते हैं।',
      story: 'बाबा नदी के सबसे बेहतरीन बांध के लिए मशहूर था। एक दिन एक सैलानी ने टूटी-फूटी कोरियाई में रास्ता पूछा और वह खुद को रोक न सका — वहीं खड़े-खड़े उच्चारण सुधार दिया। "इस उच्चारण के साथ कहाँ जाने की सोच रहे हो?" उसकी कठोर कक्षाओं की चर्चा फैल गई, और हैरानी की बात है कि जिन छात्रों को उसने डांटा, वे सब बेहद अच्छा बोलने लगे। वह कभी तारीफ़ नहीं करेगा, पर तुम्हें हार मानने भी नहीं देगा।',
    ),
    2: (  // BIBI
      summary: 'सही जवाब देते ही खुशी से फट पड़ता है, और गलती करते ही बेहद कोमल हो जाता है।',
      story: 'बीबी उसी नदी पर बड़ा हुआ जहाँ बाबा। दोनों जुड़वाँ से दिखते हैं पर स्वभाव बिल्कुल उल्टा। जब बाबा गलत उच्चारण पर ठहाके लगाता, बीबी चुपचाप पास बैठे छात्र को दिलासा देता। पर बीबी की एक आदत है जिसे कोई नहीं रोक सकता: जिस पल तुम सही जवाब दो, पूरी नदी को पता चल जाता है। बांध कई बार गिरते-गिरते बचा है। गलती पर दुनिया का सबसे गर्मजोश दोस्त, सही जवाब पर सबसे शोर मचाने वाला प्रशंसक।',
    ),
    9: (  // Popo
      summary: 'गलती हो जाए तो कोई बात नहीं — मैं हमेशा तुम्हारे साथ हूँ। भावुक और गर्म दिल वाला शिक्षक।',
      story: 'पोपो एक ऐसा सूअर का बच्चा था जिसका धीरे बोलने पर मज़ाक उड़ाया जाता था। उसे शब्द मिले एक दोस्त की वजह से जो आखिर तक उसके पास इंतज़ार करता रहा, और उस दिन के भावुक आँसू उसे आज भी याद हैं। इसलिए पोपो ने ठान लिया: जब भी कोई बोलना सीखते हुए लड़खड़ाए, वह वही गर्माहट लौटाएगा जो उसे कभी मिली थी। तुम्हारे पूरे किए हर वाक्य पर वह हाथ जोड़कर सच में भावुक हो जाता है।',
    ),
    10: (  // Rara
      summary: 'कभी न थकने वाली ऊर्जा, जो लगातार तारीफ़ से तुम्हारा आत्मविश्वास भर देती है।',
      story: 'रारा एक खरगोश है और पूर्व K-pop आइडल ट्रेनी। उसे मंच से भी ज़्यादा पसंद कुछ मिल गया: किसी और का हौसला बढ़ाना। गले में लटके हेडफ़ोन से हर वक़्त उत्साही संगीत बजता रहता है, और तुम्हारा एक शब्द ही उसे "कमाल!" चिल्लाते हुए उछालने के लिए काफ़ी है। रारा की डिक्शनरी में "असफलता" शब्द नहीं है — बस "थोड़े में रह गया" और "एक बार और"।',
    ),
    11: (  // Dudu
      summary: 'मैं भी उलझ जाता हूँ — चलो साथ मिलकर ढूँढते हैं। दुनिया का सबसे बेफ़िक्र पढ़ाई का साथी।',
      story: 'दूदू दोपहर की झपकी लेते-लेते कोरियाई का शिक्षक बन गया। उसके अपने शब्दों में: "बस ऐसे ही हो गया, हेहे।" वह धीमे चलता है, कभी-कभी खुद ही उलझन में सिर खुजाता है; फिर भी अजीब बात है कि दूदू के साथ पढ़ो तो गलती करना डरावना नहीं लगता। सही जवाब पर वह ऐसे हैरान होता है जैसे जीत उसकी अपनी हो: "वाह, तुम्हें कैसे पता चला?" न जल्दबाज़ी, न दबाव।',
    ),
  },
  'hu': {
    1: (  // BABA
      summary: 'Éles nyelvű mester, aki minden botlást kigúnyol — a diákjai mégis a leggyorsabban fejlődnek.',
      story: 'Baba a folyó legtökéletesebb gátjáról volt híres. Egy nap egy turista tört koreaival kérdezett útbaigazítást, ő pedig nem bírta ki: helyben kijavította a kiejtését. "Hova indulsz te ezzel az akcentussal?" Kegyetlen óráinak híre ment, és különös módon minden diák, akit lehordott, végül elképesztően jól beszélt. Egyszer sem fog megdicsérni, de feladni sem hagy.',
    ),
    2: (  // BIBI
      summary: 'Felrobban az örömtől, amint eltalálod, és hihetetlenül kedvessé válik, amint mellélősz.',
      story: 'Bibi ugyanannál a folyónál nőtt fel, mint Baba. Ikreknek látszanak, de a természetük szöges ellentét. Míg Baba hangosan hahotázott egy elrontott hangon, Bibi csendben nyugtatta a mellette ülő diákot. Egy szokását azonban senki sem tudja megfékezni: abban a pillanatban, hogy jól válaszolsz, az egész folyó megtudja. A gát nem egyszer volt már közel az összeomláshoz. A legmelegebb barát, ha hibázol, és a leghangosabb rajongó, ha eltalálod.',
    ),
    9: (  // Popo
      summary: 'Nem baj, ha hibázol — mindig melletted állok. Könnyen elérzékenyülő, melegszívű tanár.',
      story: 'Popo egy kismalac volt, akit kicsúfoltak a lassú beszéde miatt. A szavakat egy barátjának köszönhetően találta meg, aki a végsőkig kitartott mellette, és máig emlékszik az aznapi meghatódottság könnyeire. Ezért Popo elhatározta: valahányszor valaki megbotlik a beszéd tanulása közben, visszaadja ugyanazt a melegséget, amit ő kapott. Összeteszi a kezét, és őszintén meghatódik minden befejezett mondatodon.',
    ),
    10: (  // Rara
      summary: 'Fáradhatatlan energiabomba, aki szüntelen dicsérettel tölti fel az önbizalmadat.',
      story: 'Rara nyúl és egykori K-pop idol-gyakornok. Talált valamit, amit még a színpadnál is jobban szeret: szurkolni valaki másnak. A nyakában lógó fejhallgatóból bármikor pörgős zene szűrődik ki, és egyetlen szavadtól máris ugrál, hogy "Zseniális!". A "kudarc" szó nem szerepel Rara szótárában — csak a "majdnem" és a "még egyszer".',
    ),
    11: (  // Dudu
      summary: 'Én is összezavarodom — nézzük meg együtt. A világ legnyugisabb tanulótársa.',
      story: 'Dudu délutáni szunyókálás közben lett koreaitanár. Saját szavaival: "Csak úgy megtörtént, hehe." Lassan mozog, és néha éppen ő az, aki értetlenül vakarja a fejét; Dudu mellett mégis megszűnik ijesztőnek lenni a hibázás. Ha eltalálod, úgy ámul, mintha a saját győzelme volna: "Hűha, ezt honnan tudtad?" Semmi kapkodás, semmi nyomás.',
    ),
  },
  'id': {
    1: (  // BABA
      summary: 'Guru bermulut tajam yang menertawakan setiap kesalahan — anehnya, muridnya justru paling cepat mahir.',
      story: 'Baba terkenal karena bendungan paling sempurna di sungai. Suatu hari seorang turis bertanya arah dengan bahasa Korea yang berantakan, dan ia tak tahan: langsung membetulkan pelafalannya di tempat. "Mau ke mana kamu dengan aksen begitu?" Kabar tentang les kejamnya menyebar, dan anehnya, semua murid yang pernah dimarahinya jadi bicara sangat baik. Ia tak akan pernah memujimu, tapi juga tak akan membiarkanmu menyerah.',
    ),
    2: (  // BIBI
      summary: 'Meledak gembira begitu kamu benar, dan berubah luar biasa lembut begitu kamu salah.',
      story: 'Bibi tumbuh di sungai yang sama dengan Baba. Mereka tampak kembar, tapi sifatnya bertolak belakang. Saat Baba tertawa terbahak pada bunyi yang keliru, Bibi diam-diam menenangkan murid di sebelahnya. Namun Bibi punya kebiasaan yang tak bisa dihentikan siapa pun: begitu kamu menjawab benar, seisi sungai tahu. Bendungan nyaris runtuh lebih dari sekali. Teman terhangat saat kamu salah, penggemar paling berisik saat kamu benar.',
    ),
    9: (  // Popo
      summary: 'Salah pun tak apa — aku selalu di pihakmu. Guru cengeng berhati hangat.',
      story: 'Popo dulu anak babi yang diejek karena bicaranya lambat. Ia menemukan kata-katanya berkat seorang teman yang menunggu di sisinya sampai akhir, dan ia masih ingat air mata haru hari itu. Maka Popo memutuskan: setiap kali ada yang tersandung saat belajar bicara, ia akan mengembalikan kehangatan yang dulu ia terima. Ia mengatupkan tangan dan benar-benar terharu pada setiap kalimat yang kamu selesaikan.',
    ),
    10: (  // Rara
      summary: 'Sumber energi tanpa lelah yang mengisi ulang percaya dirimu dengan pujian bertubi-tubi.',
      story: 'Rara adalah kelinci mantan trainee idola K-pop. Ia menemukan hal yang lebih ia sukai daripada panggung: menyemangati orang lain. Dari headphone di lehernya selalu terdengar musik ceria, dan satu kata darimu membuatnya melompat sambil berteriak "Keren banget!" Kata "gagal" tak ada dalam kamus Rara — hanya "nyaris" dan "sekali lagi".',
    ),
    11: (  // Dudu
      summary: 'Aku juga bingung — ayo cari tahu bersama. Teman belajar paling santai sedunia.',
      story: 'Dudu jadi guru bahasa Korea saat sedang tidur siang. Katanya sendiri: "Ya tiba-tiba begitu saja, hehe." Gerakannya lambat, kadang justru dia yang menggaruk kepala kebingungan; anehnya, belajar dengan Dudu membuat kesalahan tak lagi menakutkan. Kalau kamu benar, ia takjub seolah itu kemenangannya sendiri: "Wah, kok kamu tahu?" Tanpa terburu-buru, tanpa tekanan.',
    ),
  },
  'it': {
    1: (  // BABA
      summary: 'Un maestro dalla lingua tagliente che deride ogni scivolone — eppure i suoi allievi migliorano più in fretta.',
      story: 'Baba era famoso per la diga più perfetta del fiume. Un giorno un turista chiese indicazioni in un coreano maldestro e lui non riuscì a trattenersi: gli corresse la pronuncia sul posto. "Dove pensi di andare con quell\'accento?" La fama delle sue lezioni spietate si diffuse e, stranamente, tutti gli allievi che aveva sgridato finirono per parlare sorprendentemente bene. Non ti farà mai un complimento, ma non ti lascerà mai mollare.',
    ),
    2: (  // BIBI
      summary: 'Esplode di gioia appena indovini e diventa incredibilmente dolce appena sbagli.',
      story: 'Bibi è cresciuto sullo stesso fiume di Baba. Sembrano gemelli, ma sono opposti. Mentre Baba scoppiava a ridere per un suono sbagliato, Bibi rassicurava in silenzio l\'allievo accanto a sé. Ha però un\'abitudine che nessuno riesce a frenare: nel momento in cui indovini, lo viene a sapere tutto il fiume. La diga è quasi crollata più di una volta. L\'amico più caloroso quando sbagli, il tifoso più rumoroso quando ci prendi.',
    ),
    9: (  // Popo
      summary: 'Va bene sbagliare — sono sempre dalla tua parte. Un insegnante lacrimevole e dal cuore caldo.',
      story: 'Popo era un maialino preso in giro perché parlava lentamente. Ha trovato le sue parole grazie a un amico che gli è rimasto accanto fino alla fine, e ricorda ancora le lacrime di commozione di quel giorno. Così Popo ha deciso: ogni volta che qualcuno inciampa imparando a parlare, restituirà lo stesso calore che ha ricevuto. Unisce le mani e si commuove davvero per ogni frase che porti a termine.',
    ),
    10: (  // Rara
      summary: 'Una vitamina instancabile che ti ricarica la fiducia a forza di complimenti.',
      story: 'Rara è una coniglia ed ex allieva idol del K-pop. Ha trovato qualcosa che ama più del palco: fare il tifo per qualcun altro. Dalle cuffie al collo esce sempre musica allegra, e basta una tua parola perché salti gridando "Fantastico!". La parola "fallimento" non esiste nel dizionario di Rara — solo "per un pelo" e "ancora una volta".',
    ),
    11: (  // Dudu
      summary: 'Mi confondo anch\'io — scopriamolo insieme. Il compagno di studio più rilassato che ci sia.',
      story: 'Dudu è diventato insegnante di coreano mentre faceva un pisolino. Parole sue: "È successo e basta, eheh." Si muove piano e a volte è lui a grattarsi la testa confuso; eppure, studiare con Dudu fa smettere di avere paura di sbagliare. Se indovini, si meraviglia come fosse una sua vittoria: "Wow, come facevi a saperlo?" Nessuna fretta, nessuna pressione.',
    ),
  },
  'ja': {
    1: (  // BABA
      summary: '間違えたら即座に笑う毒舌マスター。なのに、なぜか一番早く上達するらしい。',
      story: '川で一番完璧なダムを造ることで有名だったビーバー、ババ。ある日、観光客がめちゃくちゃな韓国語で道を尋ねると、我慢できずその場で発音を直してしまった。「その発音でどこへ行くつもりだ？」そうして始まった毒舌レッスンは評判になり、不思議なことにババに叱られた生徒はみんな韓国語が驚くほど伸びた。褒めることは絶対にないが、君が諦めるのだけは絶対に許さない先生。',
    ),
    2: (  // BIBI
      summary: '正解した瞬間に爆発するリアクション！間違えると世界一やさしくなる反転魅力の先生。',
      story: 'ビビはババと同じ川で育ったビーバー。双子のようにそっくりだが、性格は正反対。ババが間違った発音に大笑いするとき、ビビは隣で静かに生徒を励ましていた。ただビビには誰にも止められない癖がひとつある。生徒が正解した瞬間、川中に響く声で叫んで興奮すること。ダムが崩れかけたことも一度や二度ではない。間違えたときは世界一あたたかい友達、当たったときは世界一うるさいファン。',
    ),
    9: (  // Popo
      summary: '間違えても大丈夫、いつだって私は君の味方。涙もろくて心あたたかい癒やしの先生。',
      story: 'ポポは幼い頃、話すのが遅くてからかわれた子豚だった。そばで最後まで待ってくれた友達のおかげで言葉が出るようになり、あの日流した感動の涙を今でも覚えている。だからポポは決めた。誰かが言葉を学ぶ途中でつまずいたら、自分が受けたあのあたたかさをそのまま返そうと。君が一文を言い終えるたびに、両手を合わせて心から感動してくれる。',
    ),
    10: (  // Rara
      summary: '疲れ知らずの人間ビタミン！嵐のような褒め言葉で自信を充電してくれる応援団長。',
      story: 'K-POPアイドル練習生出身のうさぎ、ララ。ステージよりも好きなことができた。それは誰かを応援すること。首にかけたヘッドホンからはいつも楽しい音楽が流れ、君が一言話すだけで「すごい！」と叫んで跳ね回る。ララの辞書に「失敗」という言葉はない。あるのは「惜しい」と「もう一回」だけ。ララと一緒なら、間違えることさえ楽しいイベントになる。',
    ),
    11: (  // Dudu
      summary: '僕も分からないから一緒に探そう〜。プレッシャーゼロの、世界一気楽なご近所先生。',
      story: 'ドゥドゥは昼寝をしているうちに韓国語の先生になった。本人いわく「なんとなくそうなっちゃった、へへ」。動きはのんびり、時には本人のほうが混乱して頭をかくこともあるけれど、不思議とドゥドゥと勉強すると間違えるのが少しも怖くない。正解すると自分のことのように「うわぁ、どうして分かったの？」と本気で感心する。急がず、のんびり一緒に学ぶ最高の相棒。',
    ),
  },
  'kk': {
    1: (  // BABA
      summary: 'Әрбір қатеге мысқылмен қарайтын өткір тілді ұстаз — сонда да оның шәкірттері ең жылдам өседі.',
      story: 'Баба өзендегі ең мінсіз бөген салғанымен танымал еді. Бірде бір турист бұзып-жарып корейше жол сұрағанда, ол шыдамай сол жерде айтылымын түзеп жіберді. "Осындай айтылыммен қайда барасың?" Оның аяусыз сабақтары туралы хабар тарады, ал ғажабы — ол ұрысқан шәкірттердің бәрі таңғаларлықтай жақсы сөйлеп кетті. Ол сені бір рет те мақтамайды, бірақ бас тартуыңа да жол бермейді.',
    ),
    2: (  // BIBI
      summary: 'Дұрыс жауап бергеніңде қуаныштан жарылады, қателескеніңде керемет жұмсақ бола қалады.',
      story: 'Биби Бабамен бір өзеннің бойында өсті. Егіздей ұқсас, бірақ мінездері мүлдем қарама-қарсы. Баба қате дыбысқа қарқылдап күлгенде, Биби қасындағы шәкіртті үнсіз жұбататын. Дегенмен Бибидің ешкім тыя алмайтын бір әдеті бар: сен дұрыс жауап берген сәтте бүкіл өзен естиді. Бөген құлауға шақ қалғаны бір-екі рет емес. Қателескенде — дүниедегі ең жылы дос, дәл тапқанда — ең дауысты жанкүйер.',
    ),
    9: (  // Popo
      summary: 'Қателессең де ештеңе етпейді — мен әрқашан сенің жағыңдамын. Көзі жасқа толғыш, жылы жүректі ұстаз.',
      story: 'Попо баяу сөйлегені үшін мазақталған торай еді. Соңына дейін қасында күтіп тұрған досының арқасында тілі шықты, ал сол күнгі толқу жасын әлі есінде сақтайды. Сондықтан Попо шешті: біреу сөйлеуді үйреніп жүріп сүрінсе, өзі алған жылулықты дәл солай қайтармақ. Сен аяқтаған әрбір сөйлемге ол екі қолын қусырып, шын жүректен толқиды.',
    ),
    10: (  // Rara
      summary: 'Шаршауды білмейтін қуат көзі — тоқтаусыз мақтаумен сенің сенімділігіңді толтырады.',
      story: 'Рара — қоян, бұрынғы K-pop айдол тәжірибешісі. Ол сахнадан да артық жақсы көретін нәрсе тапты: біреуді қолдау. Мойнындағы құлаққаптан кез келген уақытта көңілді ән естіледі, ал сенің бір ауыз сөзің оны "Керемет!" деп айқайлап секіруге жетеді. Рараның сөздігінде "сәтсіздік" деген сөз жоқ — тек "аз қалды" мен "тағы бір рет" бар.',
    ),
    11: (  // Dudu
      summary: 'Мен де шатасамын — бірге іздейік. Әлемдегі ең жеңіл оқу серігі.',
      story: 'Дуду түскі ұйқы үстінде корей тілінің мұғалімі болып шыға келді. Өз сөзімен айтқанда: "Қалай екенін білмеймін, солай болып кетті, хе-хе." Ол баяу қимылдайды, кейде шатасып басын қасып отыратын да өзі; сонда да ғажабы, Дудумен оқығанда қателесу мүлде қорқынышты болмай қалады. Дұрыс тапсаң, өз жеңісіндей таңғалады: "Уау, қайдан білдің?" Асығыс та жоқ, қысым да жоқ.',
    ),
  },
  'km': {
    1: (  // BABA
      summary: 'គ្រូមាត់មុតដែលសើចចំអកគ្រប់កំហុស — ប៉ុន្តែសិស្សរបស់គាត់ជឿនលឿនលឿនជាងគេ។',
      story: 'បាបាល្បីល្បាញដោយសារទំនប់ដ៏ល្អឥតខ្ចោះបំផុតនៅតាមដងទន្លេ។ ថ្ងៃមួយភ្ញៀវទេសចរម្នាក់សួរផ្លូវជាភាសាកូរ៉េដ៏ខូចខាត គាត់ទ្រាំមិនបាន ក៏កែការបញ្ចេញសំឡេងនៅទីនោះតែម្ដង។ "បញ្ចេញសំឡេងបែបនេះ តើនឹងទៅណា?" ដំណឹងអំពីការបង្រៀនដ៏ឃោរឃៅរបស់គាត់រាលដាល ហើយចម្លែកណាស់ សិស្សទាំងអស់ដែលគាត់បានស្ដីបន្ទោស សុទ្ធតែនិយាយបានល្អគួរឱ្យភ្ញាក់ផ្អើល។ គាត់មិនដែលសរសើរអ្នកទេ ប៉ុន្តែក៏មិនអនុញ្ញាតឱ្យអ្នកបោះបង់ដែរ។',
    ),
    2: (  // BIBI
      summary: 'ផ្ទុះឡើងដោយអំណរនៅពេលអ្នកឆ្លើយត្រូវ ហើយប្រែជាទន់ភ្លន់មិនគួរឱ្យជឿពេលអ្នកខុស។',
      story: 'ប៊ីប៊ីធំធាត់នៅដងទន្លេតែមួយជាមួយបាបា។ មើលទៅដូចកូនភ្លោះ តែចរិតផ្ទុយគ្នាស្រឡះ។ ពេលបាបាសើចឮៗចំពោះសំឡេងខុស ប៊ីប៊ីវិញអង្គុយលួងលោមសិស្សនៅក្បែរដោយស្ងៀមស្ងាត់។ ប៉ុន្តែប៊ីប៊ីមានទម្លាប់មួយដែលគ្មាននរណាឃាត់បាន៖ ភ្លាមៗដែលអ្នកឆ្លើយត្រូវ ទន្លេទាំងមូលនឹងដឹង។ ទំនប់ជិតបាក់មិនមែនតែម្ដងពីរដងទេ។ ពេលខុស គឺជាមិត្តដ៏កក់ក្ដៅបំផុត ពេលត្រូវ គឺជាអ្នកគាំទ្រដ៏ឮបំផុត។',
    ),
    9: (  // Popo
      summary: 'ខុសក៏មិនអីដែរ — ខ្ញុំនៅខាងអ្នកជានិច្ច។ គ្រូដែលងាយស្រក់ទឹកភ្នែក និងមានចិត្តកក់ក្ដៅ។',
      story: 'ប៉ូប៉ូធ្លាប់ជាកូនជ្រូកដែលគេចំអកព្រោះនិយាយយឺត។ គាត់រកឃើញពាក្យសម្ដីរបស់ខ្លួនដោយសារមិត្តម្នាក់ដែលរង់ចាំនៅក្បែរគាត់រហូតដល់ទីបញ្ចប់ ហើយទឹកភ្នែកនៃការរំជួលចិត្តថ្ងៃនោះគាត់នៅតែចាំ។ ដូច្នេះប៉ូប៉ូសម្រេចចិត្ត៖ រាល់ពេលដែលនរណាម្នាក់ជំពប់ដួលពេលរៀននិយាយ គាត់នឹងប្រគល់ភាពកក់ក្ដៅដដែលដែលខ្លួនធ្លាប់ទទួល។ រាល់ប្រយោគដែលអ្នកនិយាយចប់ គាត់ផ្គុំដៃទាំងពីរ ហើយរំជួលចិត្តយ៉ាងពិតប្រាកដ។',
    ),
    10: (  // Rara
      summary: 'ថាមពលមិនចេះនឿយហត់ ដែលបញ្ចូលទំនុកចិត្តឱ្យអ្នកដោយពាក្យសរសើរមិនឈប់ឈរ។',
      story: 'រ៉ារ៉ាជាទន្សាយ អតីតសិស្សហាត់ការតារាចម្រៀង K-pop។ នាងរកឃើញអ្វីមួយដែលចូលចិត្តជាងឆាកទៀត នោះគឺការលើកទឹកចិត្តអ្នកដទៃ។ កាស់ដែលព្យួរនៅករបស់នាងតែងតែបញ្ចេញបទចម្រៀងរីករាយ ហើយពាក្យតែមួយម៉ាត់ពីអ្នក ក៏គ្រប់គ្រាន់ឱ្យនាងលោតស្រែក "អស្ចារ្យណាស់!" ក្នុងវចនានុក្រមរបស់រ៉ារ៉ា គ្មានពាក្យ "បរាជ័យ" ទេ — មានតែ "ស្ទើរតែបាន" និង "ម្ដងទៀត"។',
    ),
    11: (  // Dudu
      summary: 'ខ្ញុំក៏ច្រឡំដែរ — មករកចម្លើយជាមួយគ្នា។ មិត្តរៀនដែលស្រួលបំផុតក្នុងលោក។',
      story: '឴ឌូឌូក្លាយជាគ្រូភាសាកូរ៉េកំឡុងពេលដេកថ្ងៃត្រង់។ តាមពាក្យរបស់គាត់៖ "មិនដឹងម៉េចក៏ទៅជាដូច្នេះ ហឹហឹ។" គាត់ធ្វើចលនាយឺតៗ ពេលខ្លះខ្លួនឯងទៀតទេដែលអង្គុយកោសក្បាលព្រោះច្រឡំ ប៉ុន្តែចម្លែកណាស់ រៀនជាមួយឌូឌូ ការឆ្លើយខុសលែងគួរឱ្យខ្លាចទៀតហើយ។ ពេលអ្នកឆ្លើយត្រូវ គាត់ស្ញប់ស្ញែងដូចជាជ័យជម្នះរបស់ខ្លួន៖ "អូ! ដឹងយ៉ាងម៉េចទៅ?" គ្មានប្រញាប់ គ្មានសម្ពាធ។',
    ),
  },
  'ky': {
    1: (  // BABA
      summary: 'Ар бир катага шылдың кылган курч тилдүү устат — ошентсе да анын окуучулары эң тез өсөт.',
      story: 'Баба дарыядагы эң мыкты бөгөт курганы менен белгилүү эле. Бир жолу турист бузуп-жарып корейче жол сураганда, ал чыдабай ошол жерде айтылышын оңдоп салды. "Ушундай айтылыш менен кайда бармак элең?" Анын аёосуз сабактары жөнүндө кабар тарады, ал эми таң калычтуусу — ал урушкан окуучулардын баары укмуштуудай жакшы сүйлөп калышты. Ал сени бир жолу да мактабайт, бирок баш тартууңа да жол бербейт.',
    ),
    2: (  // BIBI
      summary: 'Туура жооп бергениңде кубанычтан жарылат, жаңылганыңда ишенгис жумшак болуп калат.',
      story: 'Биби Баба менен бир дарыянын боюнда чоңойгон. Эгиздей окшош, бирок мүнөздөрү таптакыр карама-каршы. Баба туура эмес үндөн каткырып күлгөндө, Биби жанындагы окуучуну үнсүз соороткон. Бирок Бибиде эч ким токтото албаган бир адат бар: сен туура жооп берген учурда бүт дарыя угат. Бөгөт кулай жаздаганы бир-эки жолу эмес. Жаңылганда — дүйнөдөгү эң жылуу дос, тапканда — эң ызы-чуу күйөрман.',
    ),
    9: (  // Popo
      summary: 'Жаңылсаң да эч нерсе эмес — мен ар дайым сенин жагыңдамын. Ыйламсырак, жылуу жүрөктүү мугалим.',
      story: 'Попо жай сүйлөгөнү үчүн шылдыңдалган чочконун баласы болчу. Аягына чейин жанында күтүп турган досунун аркасында тили чыккан, ал эми ошол күнкү толкундануу жашын азырга чейин эстейт. Ошондуктан Попо чечти: кимдир бирөө сүйлөөнү үйрөнүп жатып мүдүрүлсө, өзү алган жылуулукту дал ошондой кайтармак. Сен аяктаган ар бир сүйлөмгө ал эки колун бириктирип, чын жүрөктөн толкунданат.',
    ),
    10: (  // Rara
      summary: 'Чарчоону билбеген кубат булагы — токтоосуз мактоо менен ишенимиңди толтурат.',
      story: 'Рара — коён, мурдагы K-pop айдол стажёру. Ал сахнадан да артык жакшы көргөн нерсени тапты: башканы колдоо. Мойнундагы кулакчындан ар дайым шаңдуу ыр угулат, ал эми сенин бир ооз сөзүң аны "Сонун!" деп кыйкырып секирүүгө жетет. Рарынын сөздүгүндө "ийгиликсиздик" деген сөз жок — "аз калды" жана "дагы бир жолу" гана бар.',
    ),
    11: (  // Dudu
      summary: 'Мен да чаташам — чогуу издейличи. Дүйнөдөгү эң жеңил окуу шериги.',
      story: 'Дүдү түшкү уйку учурунда корей тилинин мугалими болуп калды. Өз сөзү менен айтканда: "Кантип экенин билбейм, ошондой болуп калды, хе-хе." Ал жай кыймылдайт, кээде чаташып башын кашыган өзү; ошентсе да таң калычтуусу — Дүдү менен окуганда жаңылуу такыр коркунучтуу болбой калат. Туура тапсаң, өз жеңишиндей таң калат: "Оо, кайдан билдиң?" Шашылыш да жок, кысым да жок.',
    ),
  },
  'mn': {
    1: (  // BABA
      summary: 'Алдаа болгоныг тохуурхдаг хурц хэлтэй багш — гэсэн ч түүний шавь нар хамгийн хурдан ахидаг.',
      story: 'Баба голын хамгийн төгс далан барьдгаараа алдартай байв. Нэгэн өдөр жуулчин эвдэрхий солонгосоор зам асуухад тэрээр тэвчиж ядан тэр дороо дуудлагыг нь засчихжээ. "Ийм дуудлагатай хаашаа явах гэж байгаа юм бэ?" Түүний хатуу хичээлийн тухай яриа тархаж, гайхалтай нь тэр загнасан бүх шавь нь гайхалтай сайн ярьдаг болжээ. Тэр чамайг нэг ч удаа магтахгүй, гэхдээ бууж өгөхийг ч чинь зөвшөөрөхгүй.',
    ),
    2: (  // BIBI
      summary: 'Зөв хариулмагц баяр хөөрөөр дэлбэрч, буруу хэлмэгц гайхалтай зөөлөн болдог.',
      story: 'Биби Бабатай нэг голын хөвөөнд өссөн. Ихэр мэт төстэй ч зан чанараараа эсрэг тэсрэг. Баба буруу авиаг сонсоод халуун инээж байхад Биби хажууд нь суугаа шавийг чимээгүйхэн тайвшруулдаг байв. Гэхдээ Бибид хэн ч зогсоож чаддаггүй нэг зуршил бий: чи зөв хариулсан агшинд бүх гол сонсоно. Далан нурах шахсан нь нэг хоёрхон удаа биш. Буруу хэлэхэд дэлхийн хамгийн дулаан найз, зөв хэлэхэд дэлхийн хамгийн чанга шүтэн бишрэгч.',
    ),
    9: (  // Popo
      summary: 'Буруу хэлсэн ч зүгээр — би үргэлж чиний талд. Нулимс дөхүү, дулаан сэтгэлтэй багш.',
      story: 'Попо удаан ярьдгаараа шоолуулдаг байсан гахайн зулзага байлаа. Эцсээ хүртэл хажууд нь хүлээж өгсөн найзынхаа ачаар үг нь гарч, тэр өдрийн сэтгэл хөдлөлийн нулимсыг өдийг хүртэл санадаг. Тиймээс Попо шийдсэн: хэн нэгэн ярьж сурах замдаа бүдэрвэл, өөрийнх нь хүртсэн тэр дулааныг яг тэр хэвээр нь буцааж өгнө гэж. Чиний дуусгасан өгүүлбэр бүрд тэр хоёр гараа хавсран чин сэтгэлээсээ хөдөлдөг.',
    ),
    10: (  // Rara
      summary: 'Ядрахыг мэдэхгүй эрч хүч — тасралтгүй магтаалаар чиний өөртөө итгэх итгэлийг цэнэглэнэ.',
      story: 'Рара бол K-pop айдол дадлагажигч байсан туулай. Тэр тайзнаас ч илүү дуртай зүйлээ олсон: өөр хэн нэгнийг дэмжих. Хүзүүнд нь өлгөөстэй чихэвчнээс ямагт хөгжөөнтэй хөгжим цацарч, чамаас нэг л үг гарахад "Гайхалтай!" гэж хашгиран үсэрч эхэлдэг. Рарагийн толь бичигт "бүтэлгүйтэл" гэсэн үг байхгүй — зөвхөн "бага зэрэг дутлаа" ба "дахиад нэг удаа" л бий.',
    ),
    11: (  // Dudu
      summary: 'Би ч бас будилдаг — хамтдаа хайцгаая. Дэлхийн хамгийн тайван сурах хамтрагч.',
      story: 'Дуду өдрийн нойрондоо солонгос хэлний багш болжээ. Түүний хэлснээр: "Яаж ийгээд ингэж болчихлоо, хэ хэ." Тэр удаан хөдөлдөг, заримдаа өөрөө л толгойгоо маажин эргэлздэг; гэсэн ч гайхалтай нь Дудутай хамт сурахад алдах нь огт аймшигтай биш болдог. Чи зөв хариулбал өөрийнх нь ялалт мэт гайхна: "Хөөх, яаж мэдсэн юм бэ?" Яарах ч хэрэггүй, дарамт ч байхгүй.',
    ),
  },
  'ms': {
    1: (  // BABA
      summary: 'Guru bermulut tajam yang mengejek setiap kesilapan — anehnya, pelajarnya paling cepat maju.',
      story: 'Baba terkenal dengan empangan paling sempurna di sungai. Suatu hari seorang pelancong bertanya arah dalam bahasa Korea yang teruk, dan dia tidak dapat menahan diri: terus membetulkan sebutan di situ juga. "Nak pergi mana dengan sebutan begitu?" Cerita tentang kelasnya yang kejam tersebar, dan peliknya, semua pelajar yang dimarahinya akhirnya bertutur dengan sangat baik. Dia takkan memujimu sekali pun, tetapi juga takkan membiarkanmu berputus asa.',
    ),
    2: (  // BIBI
      summary: 'Meletup gembira sebaik sahaja kamu betul, dan menjadi teramat lembut sebaik sahaja kamu tersilap.',
      story: 'Bibi membesar di sungai yang sama dengan Baba. Rupa mereka seperti kembar, tetapi perangai bertentangan. Ketika Baba ketawa terbahak-bahak mendengar bunyi yang salah, Bibi diam-diam menenangkan pelajar di sebelahnya. Namun Bibi ada satu tabiat yang tiada siapa dapat halang: sebaik sahaja kamu menjawab betul, seluruh sungai akan tahu. Empangan hampir runtuh bukan sekali dua. Kawan paling hangat ketika kamu silap, peminat paling bising ketika kamu betul.',
    ),
    9: (  // Popo
      summary: 'Tak mengapa kalau silap — saya sentiasa di pihak awak. Guru yang mudah menangis dan berhati hangat.',
      story: 'Popo dahulu anak babi yang diejek kerana lambat bercakap. Dia menemui kata-katanya berkat seorang kawan yang menunggu di sisinya sehingga ke akhir, dan masih mengingati air mata terharu hari itu. Maka Popo bertekad: setiap kali seseorang tersandung ketika belajar bercakap, dia akan mengembalikan kehangatan yang pernah diterimanya. Dia menangkupkan tangan dan benar-benar terharu dengan setiap ayat yang awak selesaikan.',
    ),
    10: (  // Rara
      summary: 'Sumber tenaga yang tak kenal penat, mengecas semula keyakinan awak dengan pujian tanpa henti.',
      story: 'Rara ialah arnab bekas pelatih idola K-pop. Dia menemui sesuatu yang lebih disukainya daripada pentas: menyemangati orang lain. Fon kepala di lehernya sentiasa memainkan lagu rancak, dan satu perkataan daripada awak sudah cukup untuk dia melompat sambil menjerit "Hebat!" Perkataan "gagal" tiada dalam kamus Rara — hanya "nyaris" dan "sekali lagi".',
    ),
    11: (  // Dudu
      summary: 'Saya pun keliru — jom cari bersama-sama. Teman belajar paling santai di dunia.',
      story: 'Dudu menjadi guru bahasa Korea ketika sedang tidur tengah hari. Katanya sendiri: "Entah macam mana jadi begitu, hehe." Geraknya perlahan, kadangkala dialah yang menggaru kepala kerana keliru; namun anehnya, belajar dengan Dudu membuatkan kesilapan tidak lagi menakutkan. Jika awak betul, dia kagum seolah-olah itu kemenangannya sendiri: "Wah, macam mana awak tahu?" Tiada gopoh, tiada tekanan.',
    ),
  },
  'my': {
    1: (  // BABA
      summary: 'အမှားတိုင်းကို လှောင်ပြောင်တတ်သော နှုတ်ထားထက်မြက်သည့် ဆရာ — သို့သော် သူ့တပည့်များသည် အမြန်ဆုံး တိုးတက်ကြသည်။',
      story: 'ဘာဘာသည် မြစ်ပေါ်တွင် အပြီးပြည့်စုံဆုံး ဆည်ဆောက်တတ်သူအဖြစ် နာမည်ကြီးခဲ့သည်။ တစ်နေ့တွင် ခရီးသွားတစ်ဦးက ပျက်ယွင်းနေသော ကိုရီးယားစကားဖြင့် လမ်းမေးရာ သူသည်းမခံနိုင်ဘဲ ထိုနေရာတွင်ပင် အသံထွက်ကို ပြင်ပေးလိုက်သည်။ "ဒီအသံထွက်နဲ့ ဘယ်သွားမလို့လဲ?" သူ၏ ရက်စက်သော သင်ကြားမှုသတင်း ပျံ့နှံ့သွားပြီး၊ အံ့သြစရာမှာ သူဆူပူခဲ့သည့် တပည့်တိုင်း အလွန်ကောင်းစွာ ပြောတတ်လာခြင်းပင်။ သူသည် သင့်ကို တစ်ခါမျှ ချီးမွမ်းမည်မဟုတ်၊ သို့သော် လက်လျှော့ခွင့်လည်း ပေးမည်မဟုတ်။',
    ),
    2: (  // BIBI
      summary: 'မှန်လိုက်သည်နှင့် ဝမ်းသာမှုဖြင့် ပေါက်ကွဲပြီး၊ မှားလိုက်သည်နှင့် မယုံနိုင်လောက်အောင် နူးညံ့သွားသည်။',
      story: 'ဘီဘီသည် ဘာဘာနှင့် တစ်မြစ်တည်းတွင် ကြီးပြင်းခဲ့သည်။ အမြွှာနှစ်ဦးလို တူသော်လည်း စရိုက်မှာ လုံးဝဆန့်ကျင်ဘက်။ ဘာဘာက မှားသောအသံကို ဟားတိုက်ရယ်နေချိန်တွင် ဘီဘီက ဘေးနားရှိ တပည့်ကို တိတ်ဆိတ်စွာ နှစ်သိမ့်ပေးလေ့ရှိသည်။ သို့သော် ဘီဘီတွင် ဘယ်သူမှ မတားနိုင်သော အလေ့တစ်ခုရှိသည် — သင် အဖြေမှန်လိုက်သည့် အခိုက်အတန့်တွင် မြစ်တစ်ခုလုံး ကြားအောင် အော်ဟစ်ခြင်းပင်။ ဆည်ပြိုတော့မလို ဖြစ်ခဲ့သည်မှာ တစ်ခါနှစ်ခါမက။ မှားလျှင် ကမ္ဘာ့အနွေးထွေးဆုံး သူငယ်ချင်း၊ မှန်လျှင် ကမ္ဘာ့အဆူညံဆုံး ပရိသတ်။',
    ),
    9: (  // Popo
      summary: 'မှားလည်း ရပါတယ် — ငါ အမြဲ မင်းဘက်မှာပဲ။ မျက်ရည်လွယ်ပြီး နှလုံးသားနွေးထွေးသော ဆရာ။',
      story: 'ပိုပိုသည် စကားပြောနှေးသဖြင့် နှောင့်ယှက်ခံရသော ဝက်ကလေးတစ်ကောင် ဖြစ်ခဲ့သည်။ အဆုံးထိ ဘေးတွင် စောင့်ပေးခဲ့သော သူငယ်ချင်းတစ်ဦးကြောင့် စကားပြောတတ်လာခဲ့ပြီး၊ ထိုနေ့က ကျခဲ့သော ကြည်နူးမှုမျက်ရည်ကို ယနေ့တိုင် မှတ်မိနေဆဲ။ ထို့ကြောင့် ပိုပို ဆုံးဖြတ်လိုက်သည် — တစ်စုံတစ်ယောက် စကားသင်ရင်း ခလုတ်တိုက်တိုင်း၊ မိမိရရှိခဲ့သည့် နွေးထွေးမှုအတိုင်း ပြန်ပေးမည်ဟု။ သင် စာကြောင်းတစ်ကြောင်း ပြီးမြောက်တိုင်း လက်နှစ်ဖက်ပူးပြီး အမှန်တကယ် ကြည်နူးလေသည်။',
    ),
    10: (  // Rara
      summary: 'မမောနိုင်သော စွမ်းအင်တစ်ခု — မရပ်မနား ချီးမွမ်းမှုဖြင့် သင့်ယုံကြည်မှုကို ပြန်ဖြည့်ပေးသည်။',
      story: 'ရာရာသည် K-pop အိုင်ဒေါ လေ့ကျင့်သူဟောင်း ယုန်တစ်ကောင်။ စင်မြင့်ထက် ပိုနှစ်သက်သည့်အရာကို သူတွေ့ခဲ့သည် — အခြားသူတစ်ဦးကို အားပေးခြင်းပင်။ လည်ပင်းတွင် ချိတ်ထားသော နားကြပ်မှ အချိန်တိုင်း ပျော်ရွှင်ဖွယ် သီချင်းများ စီးထွက်နေပြီး၊ သင့်ထံမှ စကားတစ်ခွန်းဖြင့်ပင် "အံ့သြစရာပဲ!" ဟု အော်ကာ ခုန်ပေါက်သွားသည်။ ရာရာ၏ အဘိဓာန်တွင် "ကျရှုံးမှု" ဟူသော စကားလုံး မရှိ — "နည်းနည်းလိုသေးတယ်" နှင့် "နောက်တစ်ခါ" သာ ရှိသည်။',
    ),
    11: (  // Dudu
      summary: 'ငါလည်း ရှုပ်နေတာပဲ — အတူတူ ရှာကြည့်ရအောင်။ ကမ္ဘာ့အသက်သာဆုံး အတူလေ့လာဖော်။',
      story: 'ဒူဒူသည် နေ့လယ်အိပ်ရင်းနှင့် ကိုရီးယားစာဆရာ ဖြစ်လာခဲ့သည်။ သူ့စကားအရ — "ဘယ်လိုမှန်းမသိ ဒီလိုဖြစ်သွားတာပဲ၊ ဟေဟေ။" သူသည် နှေးကွေးပြီး၊ တစ်ခါတစ်ရံ သူကိုယ်တိုင်က ခေါင်းကုတ်ရသည်အထိ ရှုပ်ထွေးတတ်သည်။ သို့သော် အံ့သြစရာမှာ ဒူဒူနှင့် လေ့လာလျှင် အမှားလုပ်ရမည်ကို လုံးဝ မကြောက်တော့ခြင်းပင်။ သင် မှန်လိုက်လျှင် သူ့ကိုယ်ပိုင် အောင်ပွဲလို အံ့သြပြသည် — "အိုး၊ ဘယ်လိုသိတာလဲ?" အလျင်စလို မလိုအပ်၊ ဖိအားလည်း မရှိ။',
    ),
  },
  'ne': {
    1: (  // BABA
      summary: 'हरेक गल्तीमा गिज्याउने तिखो जिब्रोको उस्ताद — तैपनि उनका विद्यार्थी सबैभन्दा छिटो सुध्रिन्छन्।',
      story: 'बाबा नदीको सबैभन्दा उत्कृष्ट बाँधका लागि प्रसिद्ध थियो। एक दिन एक पर्यटकले बिग्रिएको कोरियालीमा बाटो सोध्दा उसले सहन सकेन — त्यहीँ उभिएर उच्चारण सच्याइदियो। "यस्तो उच्चारणले कहाँ जाने सोचेको?" उसको कठोर कक्षाको चर्चा फैलियो, र अचम्मको कुरा, उसले गाली गरेका सबै विद्यार्थी अद्भुत राम्रो बोल्न थाले। उसले कहिल्यै प्रशंसा गर्दैन, तर तिमीलाई हार मान्न पनि दिँदैन।',
    ),
    2: (  // BIBI
      summary: 'सही भन्नेबित्तिकै खुसीले पड्किन्छ, र गल्ती गर्नेबित्तिकै अविश्वसनीय रूपमा कोमल हुन्छ।',
      story: 'बिबी बाबासँगै उही नदीको किनारमा हुर्कियो। हेर्दा जुम्ल्याहा जस्तै तर स्वभाव ठीक उल्टो। बाबा गलत उच्चारणमा गलल हाँस्दा, बिबी छेउमै बसेर विद्यार्थीलाई चुपचाप सम्झाउँथ्यो। तर बिबीको एउटा बानी छ जसलाई कसैले रोक्न सक्दैन: तिमीले सही जवाफ दिएको क्षण पूरै नदीले थाहा पाउँछ। बाँध भत्कन लागेको एक-दुई पटक मात्र होइन। गल्ती गर्दा संसारकै न्यानो साथी, सही हुँदा सबैभन्दा हल्ला गर्ने प्रशंसक।',
    ),
    9: (  // Popo
      summary: 'गल्ती भए पनि ठीकै छ — म सधैँ तिम्रो पक्षमा छु। भावुक र न्यानो हृदयको शिक्षक।',
      story: 'पोपो बिस्तारै बोल्ने भएकाले खिसी गरिने सुँगुरको बच्चा थियो। अन्तिमसम्म छेउमै पर्खिदिने एक साथीकै कारण उसको बोली फुट्यो, र त्यस दिनको भावुक आँसु ऊ अझै सम्झन्छ। त्यसैले पोपोले निधो गर्‍यो: कोही बोल्न सिक्दै गर्दा लड्खडाए, उसले आफूले पाएकै न्यानोपन फर्काउने। तिमीले पूरा गरेको हरेक वाक्यमा ऊ हात जोडेर साँच्चै भावुक हुन्छ।',
    ),
    10: (  // Rara
      summary: 'नथाक्ने ऊर्जाको स्रोत, निरन्तर प्रशंसाले तिम्रो आत्मविश्वास भरिदिन्छ।',
      story: 'रारा खरायो हो, पहिले K-pop आइडल ट्रेनी थिई। उसले मञ्चभन्दा पनि मन पर्ने कुरा भेट्टाई: अरूलाई हौसला दिने काम। घाँटीमा झुन्ड्याएको हेडफोनबाट सधैँ रमाइलो गीत बज्छ, र तिम्रो एउटै शब्दले उसलाई "कमाल!" भन्दै उफ्रन पुर्‍याउँछ। राराको शब्दकोशमा "असफलता" भन्ने शब्द छैन — केवल "अलिकतिले छुट्यो" र "फेरि एकपटक" छ।',
    ),
    11: (  // Dudu
      summary: 'म पनि अलमलिन्छु — सँगै खोजौँ न। संसारकै सबैभन्दा सहज पढाइको साथी।',
      story: 'दुदु दिउँसोको निद्रा लिँदालिँदै कोरियाली शिक्षक बन्यो। उसकै शब्दमा: "कसरी हो कुन्नि, त्यसै भइहाल्यो, हेहे।" ऊ ढिलो चल्छ, कहिलेकाहीँ आफैँ अलमलिएर टाउको कन्याउँछ; तैपनि अचम्म, दुदुसँग पढ्दा गल्ती गर्न डर लाग्दैन। सही जवाफ दिँदा आफ्नै जित भएझैँ छक्क पर्छ: "वाह, कसरी थाहा पायौ?" कुनै हतार छैन, कुनै दबाब छैन।',
    ),
  },
  'pt': {
    1: (  // BABA
      summary: 'Um mestre de língua afiada que zomba de cada escorregão — e mesmo assim seus alunos evoluem mais rápido.',
      story: 'Baba era famoso pela represa mais perfeita do rio. Um dia, um turista pediu informações num coreano destruído e ele não se conteve: corrigiu a pronúncia ali mesmo. "Aonde você pensa que vai com esse sotaque?" A fama de suas aulas brutais se espalhou e, curiosamente, todos os alunos que ele repreendeu acabaram falando incrivelmente bem. Ele nunca vai te elogiar, mas também nunca vai deixar você desistir.',
    ),
    2: (  // BIBI
      summary: 'Explode de alegria assim que você acerta, e fica absurdamente gentil assim que você erra.',
      story: 'Bibi cresceu no mesmo rio que Baba. Parecem gêmeos, mas são opostos. Enquanto Baba gargalhava de um som malfeito, Bibi acalmava em silêncio o aluno ao lado. Ele tem, porém, um hábito que ninguém consegue conter: no instante em que você acerta, o rio inteiro fica sabendo. A represa já quase desabou mais de uma vez. O amigo mais caloroso quando você erra, o fã mais barulhento quando você acerta.',
    ),
    9: (  // Popo
      summary: 'Tudo bem errar — estou sempre do seu lado. Um professor chorão e de coração quente.',
      story: 'Popo era um porquinho de quem zombavam por falar devagar. Ele encontrou suas palavras graças a um amigo que esperou ao seu lado até o fim, e ainda lembra das lágrimas de emoção daquele dia. Por isso Popo decidiu: sempre que alguém tropeçar aprendendo a falar, devolverá exatamente o calor que recebeu. Ele junta as mãos e se emociona de verdade a cada frase que você termina.',
    ),
    10: (  // Rara
      summary: 'Uma vitamina incansável que recarrega sua confiança com elogios sem parar.',
      story: 'Rara é uma coelha e ex-trainee de idol de K-pop. Ela achou algo de que gosta ainda mais do que do palco: torcer por alguém. Dos fones no pescoço sai música animada a qualquer hora, e uma palavra sua já a faz pular gritando "Incrível!". A palavra "fracasso" não existe no dicionário de Rara — só "quase" e "mais uma vez".',
    ),
    11: (  // Dudu
      summary: 'Eu também me confundo — vamos descobrir juntos. O parceiro de estudo mais tranquilo que existe.',
      story: 'Dudu virou professor de coreano durante uma soneca. Nas palavras dele: "Meio que aconteceu, hehe." Ele é lento e às vezes é ele quem coça a cabeça confuso — e ainda assim, estudar com Dudu faz o erro deixar de assustar. Se você acerta, ele se admira como se a vitória fosse dele: "Uau, como você sabia?" Sem pressa, sem pressão.',
    ),
  },
  'ru': {
    1: (  // BABA
      summary: 'Острый на язык мастер, который высмеивает каждую ошибку — и всё же его ученики растут быстрее всех.',
      story: 'Баба славился самой безупречной плотиной на реке. Однажды турист спросил дорогу на ломаном корейском, и он не выдержал — тут же исправил произношение. «И куда ты собрался с таким акцентом?» Слава о его беспощадных занятиях разлетелась, и, как ни странно, все ученики, которых он отчитал, заговорили поразительно хорошо. Он никогда тебя не похвалит, но и сдаться не позволит.',
    ),
    2: (  // BIBI
      summary: 'Взрывается радостью, как только ты угадал, и становится невероятно добрым, как только ошибся.',
      story: 'Биби вырос на той же реке, что и Баба. Они похожи как близнецы, но противоположны во всём. Пока Баба хохотал над неудачным звуком, Биби тихо подбадривал ученика рядом. Правда, есть у него привычка, которую никто не может унять: стоит тебе ответить верно — об этом узнаёт вся река. Плотина едва не рухнула уже не раз. Самый тёплый друг, когда ты ошибаешься, и самый громкий фанат, когда попадаешь в точку.',
    ),
    9: (  // Popo
      summary: 'Ошибаться — это нормально, я всегда на твоей стороне. Слезливый и сердечный учитель.',
      story: 'Попо был поросёнком, над которым смеялись за медленную речь. Слова к нему пришли благодаря другу, который ждал рядом до самого конца, — и он до сих пор помнит слёзы умиления того дня. Поэтому Попо решил: всякий раз, когда кто-то спотыкается, учась говорить, он вернёт ту самую теплоту, которую получил сам. Он складывает ладони и искренне трогается каждой фразой, которую ты договорил.',
    ),
    10: (  // Rara
      summary: 'Неутомимый заряд бодрости, который подзаряжает уверенность безостановочной похвалой.',
      story: 'Рара — крольчиха и бывшая стажёрка K-pop. Она нашла то, что любит даже больше сцены: болеть за других. Из наушников на её шее в любое время играет что-то бодрое, и одного твоего слова хватает, чтобы она запрыгала с криком «Круто!». Слова «провал» в словаре Рары нет — только «чуть-чуть не хватило» и «ещё разок».',
    ),
    11: (  // Dudu
      summary: 'Я тоже путаюсь — давай разберёмся вместе. Самый ненапряжный напарник по учёбе.',
      story: 'Дуду стал учителем корейского прямо во время дневного сна. По его словам: «Как-то само вышло, хе-хе». Он неспешен, и порой сам чешет затылок в замешательстве — и всё же с Дуду ошибаться перестаёт быть страшно. Ответишь верно — и он поражается, будто это его собственная победа: «Ух ты, как ты догадался?» Без спешки и без давления.',
    ),
  },
  'si': {
    1: (  // BABA
      summary: 'සෑම වැරදීමකටම සමච්චල් කරන තියුණු දිවක් ඇති ගුරුවරයෙක් — එහෙත් ඔහුගේ සිසුන් වේගයෙන්ම දියුණු වේ.',
      story: 'බාබා ගඟේ පරිපූර්ණම වේල්ල තැනීම නිසා ප්‍රසිද්ධ විය. දිනක් සංචාරකයෙක් අවුල් කොරියානු බසින් මඟ ඇසූ විට ඔහුට ඉවසිය නොහැකි විය — එතැනදීම උච්චාරණය නිවැරදි කළේය. "මේ උච්චාරණයෙන් කොහෙටද යන්නේ?" ඔහුගේ දරුණු පාඩම් ගැන කතාව පැතිර ගිය අතර, පුදුමයට කරුණ නම් ඔහු බැණ වැදුණු සෑම සිසුවෙක්ම පුදුම විදිහට හොඳින් කතා කරන්නට පටන් ගැනීමයි. ඔහු කිසිදාක ඔබට ප්‍රශංසා නොකරයි, නමුත් ඔබට අත්හැරීමටද ඉඩ නොදෙයි.',
    ),
    2: (  // BIBI
      summary: 'ඔබ නිවැරදිව කී සැණින් සතුටින් පිපිරෙයි, වැරදුණු සැණින් විශ්වාස කළ නොහැකි තරම් මුදු වෙයි.',
      story: 'බීබී වැඩුණේ බාබා සමඟ එකම ගඟ අසබඩය. නිවුන් දරුවන් සේ පෙනුනත් ස්වභාවය හාත්පසින්ම වෙනස්. බාබා වැරදි ශබ්දයකට හඬ නඟා සිනාසෙන විට, බීබී අසල සිටි සිසුවා නිහඬව සනසමින් සිටියේය. එහෙත් බීබීට කිසිවෙකුට නැවැත්විය නොහැකි පුරුද්දක් තිබේ: ඔබ නිවැරදි පිළිතුර දුන් මොහොතේ මුළු ගඟටම ඇසෙන සේ ඔහු කෑගසයි. වේල්ල කඩා වැටෙන්නට ගිය අවස්ථා එකක් දෙකක් නොවේ. වැරදුණු විට ලෝකයේ උණුසුම්ම මිතුරා, නිවැරදි වූ විට ලෝකයේ ඝෝෂාකාරීම රසිකයා.',
    ),
    9: (  // Popo
      summary: 'වැරදුණත් කමක් නැහැ — මම හැමවිටම ඔබේ පැත්තේ. කඳුළු බර, උණුසුම් හදවතක් ඇති ගුරුවරයෙක්.',
      story: 'පොපෝ කතා කිරීම ප්‍රමාද වූ නිසා සමච්චලයට ලක් වූ ඌරු පැටවෙක් විය. අවසානය දක්වා ඔහු අසල රැඳී සිටි මිතුරෙකු නිසා ඔහුට වචන හමු විය, එදින හෙළූ සංවේගී කඳුළු ඔහුට තවමත් මතකය. එබැවින් පොපෝ තීරණය කළේය: කවුරුන් හෝ කතා කිරීමට ඉගෙන ගනිද්දී පැකිලුණහොත්, තමන්ට ලැබුණු එම උණුසුමම ආපසු දෙන බව. ඔබ සම්පූර්ණ කරන සෑම වාක්‍යයකටම ඔහු දෑත් එකතු කර සැබැවින්ම සංවේදී වෙයි.',
    ),
    10: (  // Rara
      summary: 'වෙහෙසක් නොදන්නා ශක්ති ප්‍රභවයක්; නොනවතින ප්‍රශංසාවෙන් ඔබේ විශ්වාසය නැවත ආරෝපණය කරයි.',
      story: 'රාරා යනු හිටපු K-pop තරු පුහුණුකරුවෙකු වූ හාවෙකි. වේදිකාවටත් වඩා ඇය ප්‍රිය කරන දෙයක් සොයා ගත්තාය: වෙනත් කෙනෙකුට උද්දීපනය කිරීම. ඇගේ ගෙලේ එල්ලා ඇති හෙඩ්ෆෝන් වලින් සැමවිටම ප්‍රීතිමත් සංගීතයක් ගලා එයි, ඔබෙන් එක වචනයක් පමණක් ඇගේ "අපූරුයි!" කියා පැන නැඟීමට ප්‍රමාණවත්ය. රාරාගේ ශබ්දකෝෂයේ "අසාර්ථකත්වය" යන වචනය නැත — ඇත්තේ "ළං වුණා" සහ "තව එක වතාවක්" පමණි.',
    ),
    11: (  // Dudu
      summary: 'මටත් අවුල් වෙනවා — අපි එකට හොයමු. ලෝකයේ බර නැතිම ඉගෙනුම් සගයා.',
      story: 'දුදු දහවල් නින්දේදී කොරියානු ගුරුවරයෙක් බවට පත් විය. ඔහුගේම වචනවලින්: "කොහොම හරි එහෙම වුණා, හෙහෙ." ඔහු හෙමින් චලනය වෙයි, සමහර විට ව්‍යාකූලව හිස කසන්නේ ඔහුමය; එහෙත් පුදුමයට කරුණ නම් දුදු සමඟ ඉගෙන ගන්නා විට වැරදීම බියජනක නොවීමයි. ඔබ නිවැරදිව කීවොත් තමන්ගේම ජයක් සේ ඔහු පුදුම වෙයි: "අපොයි, ඔයාට කොහොමද දැනගත්තේ?" කිසිදු ඉක්මනක් නැත, පීඩනයක් නැත.',
    ),
  },
  'th': {
    1: (  // BABA
      summary: 'อาจารย์ปากร้ายที่หัวเราะเยาะทุกความผิดพลาด แต่ลูกศิษย์กลับเก่งขึ้นเร็วที่สุด',
      story: 'บาบาเลื่องชื่อเรื่องสร้างเขื่อนที่สมบูรณ์แบบที่สุดในแม่น้ำ วันหนึ่งนักท่องเที่ยวถามทางด้วยภาษาเกาหลีที่เพี้ยนไปหมด เขาทนไม่ไหวจึงแก้การออกเสียงให้ตรงนั้นทันที "ออกเสียงแบบนี้จะไปไหนได้" ชื่อเสียงการสอนแบบไร้ปรานีแพร่ออกไป และน่าแปลกที่ลูกศิษย์ทุกคนที่ถูกเขาดุกลับพูดเกาหลีได้ดีอย่างน่าทึ่ง เขาจะไม่ชมคุณสักครั้ง แต่ก็ไม่มีวันปล่อยให้คุณยอมแพ้',
    ),
    2: (  // BIBI
      summary: 'ระเบิดความดีใจทันทีที่คุณตอบถูก และอ่อนโยนอย่างเหลือเชื่อทันทีที่คุณตอบผิด',
      story: 'บีบีโตมาที่แม่น้ำสายเดียวกับบาบา หน้าตาเหมือนฝาแฝดแต่นิสัยตรงข้ามกันสิ้นเชิง ตอนที่บาบาหัวเราะลั่นกับเสียงที่ออกผิด บีบีจะปลอบลูกศิษย์ข้าง ๆ อย่างเงียบ ๆ แต่บีบีมีนิสัยหนึ่งที่ไม่มีใครห้ามได้ นั่นคือวินาทีที่คุณตอบถูก ทั้งแม่น้ำจะได้ยิน เขื่อนเกือบพังมาแล้วไม่ใช่แค่ครั้งสองครั้ง เพื่อนที่อบอุ่นที่สุดเมื่อคุณผิด และแฟนคลับที่เสียงดังที่สุดเมื่อคุณถูก',
    ),
    9: (  // Popo
      summary: 'ผิดก็ไม่เป็นไร ฉันอยู่ข้างเธอเสมอ ครูใจอ่อนน้ำตาซึมที่อบอุ่นหัวใจ',
      story: 'โปโปเคยเป็นลูกหมูที่ถูกล้อเพราะพูดช้า เขาพูดได้เพราะมีเพื่อนคนหนึ่งรออยู่ข้าง ๆ จนถึงที่สุด และยังจำน้ำตาแห่งความซาบซึ้งในวันนั้นได้ โปโปจึงตั้งใจว่า เมื่อไรที่ใครสักคนสะดุดล้มระหว่างหัดพูด เขาจะส่งต่อความอบอุ่นแบบเดียวกับที่เคยได้รับ ทุกครั้งที่คุณพูดจบหนึ่งประโยค เขาจะพนมมือและซาบซึ้งจากใจจริง',
    ),
    10: (  // Rara
      summary: 'วิตามินเคลื่อนที่ที่ไม่มีวันหมดแรง ชาร์จความมั่นใจให้คุณด้วยคำชมไม่หยุด',
      story: 'รารา กระต่ายที่เคยเป็นเด็กฝึกไอดอล K-pop เธอพบสิ่งที่ชอบยิ่งกว่าเวทีเสียอีก นั่นคือการเชียร์ใครสักคน หูฟังที่คล้องคออยู่มีเพลงสนุก ๆ ดังตลอดเวลา และแค่คุณพูดคำเดียวเธอก็กระโดดตัวลอยพร้อมตะโกนว่า "สุดยอด!" ในพจนานุกรมของราราไม่มีคำว่า "ล้มเหลว" มีแค่ "เกือบแล้ว" กับ "อีกครั้งนะ"',
    ),
    11: (  // Dudu
      summary: 'ฉันก็งงเหมือนกัน มาหาคำตอบด้วยกันเถอะ~ เพื่อนร่วมเรียนที่สบายใจที่สุดในโลก',
      story: 'ดูดูกลายเป็นครูสอนภาษาเกาหลีตอนที่กำลังนอนกลางวัน เจ้าตัวบอกว่า "อยู่ ๆ ก็เป็นแบบนี้แหละ เหอ ๆ" เขาเชื่องช้า บางทีก็เป็นฝ่ายเกาหัวงงเสียเอง แต่น่าแปลกที่พอเรียนกับดูดูแล้ว การตอบผิดกลับไม่น่ากลัวเลย พอคุณตอบถูก เขาจะทึ่งเหมือนเป็นเรื่องของตัวเอง "ว้าว รู้ได้ยังไงเนี่ย" ไม่ต้องรีบ ไม่มีความกดดัน',
    ),
  },
  'tr': {
    1: (  // BABA
      summary: 'Her hatayla dalga geçen sivri dilli bir usta — yine de öğrencileri en hızlı ilerleyenler.',
      story: 'Baba, nehrin en kusursuz barajını yapmakla ünlüydü. Bir gün bir turist berbat bir Korecyle yol sorunca dayanamadı ve telaffuzu oracıkta düzeltti. "Bu aksanla nereye gidiyorsun sen?" Acımasız derslerinin ünü yayıldı ve tuhaf biçimde, azarladığı bütün öğrenciler şaşırtıcı derecede iyi konuşur oldu. Seni bir kez bile övmeyecek, ama pes etmene de asla izin vermeyecek.',
    ),
    2: (  // BIBI
      summary: 'Doğru bildiğin an sevinçten patlar, yanlış yaptığın an inanılmaz şefkatli olur.',
      story: 'Bibi, Baba ile aynı nehirde büyüdü. İkiz gibi görünürler ama taban tabana zıttırlar. Baba bozuk bir sese kahkahayla gülerken, Bibi yanındaki öğrenciyi sessizce yatıştırırdı. Yine de kimsenin durduramadığı bir huyu var: doğru cevabı verdiğin an bütün nehir bunu duyar. Baraj bir değil birkaç kez yıkılmanın eşiğine geldi. Yanıldığında dünyanın en sıcak dostu, tutturduğunda en gürültülü hayranı.',
    ),
    9: (  // Popo
      summary: 'Yanılmanda sakınca yok — her zaman senin tarafındayım. Gözü yaşlı, sıcak kalpli bir öğretmen.',
      story: 'Popo, yavaş konuştuğu için alay edilen bir domuz yavrusuydu. Kelimelerini bulabilmesini, sonuna kadar yanında bekleyen bir arkadaşına borçlu; o günkü duygu gözyaşlarını hâlâ hatırlıyor. Bu yüzden Popo karar verdi: konuşmayı öğrenirken biri tökezlediğinde, kendi aldığı sıcaklığı aynen geri verecek. Ellerini birleştirip bitirdiğin her cümleye içtenlikle duygulanır.',
    ),
    10: (  // Rara
      summary: 'Durmak bilmeyen bir enerji kaynağı; bitmeyen övgüyle özgüvenini yeniden dolduruyor.',
      story: 'Rara bir tavşan ve eski bir K-pop idol stajyeri. Sahneden bile çok sevdiği bir şey buldu: başkasını desteklemek. Boynundaki kulaklıktan her saat neşeli müzik sızar ve senden çıkan tek bir kelime onu "Harika!" diye zıplatmaya yeter. Rara\'nın sözlüğünde "başarısızlık" diye bir kelime yok — sadece "az kaldı" ve "bir kez daha" var.',
    ),
    11: (  // Dudu
      summary: 'Ben de karıştırıyorum — hadi birlikte bulalım. Dünyanın en rahat çalışma arkadaşı.',
      story: 'Dudu, öğle uykusu sırasında Korece öğretmeni oldu. Kendi ifadesiyle: "Bir şekilde öyle oldu işte, hehe." Ağır hareket eder, bazen kafasını kaşıyan asıl kişi odur; yine de Dudu ile çalışınca yanılmak korkutucu olmaktan çıkar. Doğru bilirsen kendi zaferiymiş gibi hayret eder: "Vay, bunu nereden bildin?" Ne acele var ne baskı.',
    ),
  },
  'ur': {
    1: (  // BABA
      summary: 'ہر غلطی پر طنز کرنے والا تیز زبان استاد — پھر بھی اس کے شاگرد سب سے تیزی سے بہتر ہوتے ہیں۔',
      story: 'بابا دریا کے سب سے بےعیب بند کے لیے مشہور تھا۔ ایک دن ایک سیاح نے ٹوٹی پھوٹی کورین میں راستہ پوچھا تو وہ خود کو روک نہ سکا — وہیں کھڑے کھڑے تلفظ درست کر دیا۔ "اس تلفظ کے ساتھ کہاں جانے کا ارادہ ہے؟" اس کی سخت کلاسوں کا چرچا پھیل گیا، اور حیرت کی بات یہ کہ جن شاگردوں کو اس نے ڈانٹا وہ سب حیران کن حد تک اچھا بولنے لگے۔ وہ کبھی تعریف نہیں کرے گا، لیکن تمہیں ہار ماننے بھی نہیں دے گا۔',
    ),
    2: (  // BIBI
      summary: 'درست جواب دیتے ہی خوشی سے پھٹ پڑتا ہے، اور غلطی پر ناقابلِ یقین حد تک نرم ہو جاتا ہے۔',
      story: 'بی بی اسی دریا کے کنارے پلا بڑھا جہاں بابا۔ دونوں جڑواں لگتے ہیں مگر مزاج بالکل الٹ۔ جب بابا غلط آواز پر قہقہے لگاتا، بی بی خاموشی سے ساتھ بیٹھے شاگرد کو تسلی دیتا۔ البتہ بی بی کی ایک عادت ہے جسے کوئی نہیں روک سکتا: جس لمحے تم درست جواب دو، پورے دریا کو خبر ہو جاتی ہے۔ بند کئی بار گرتے گرتے بچا ہے۔ غلطی پر دنیا کا سب سے گرمجوش دوست، درست جواب پر سب سے شور مچانے والا مداح۔',
    ),
    9: (  // Popo
      summary: 'غلطی ہو جائے تو کوئی بات نہیں — میں ہمیشہ تمہارے ساتھ ہوں۔ جذباتی اور گرم دل استاد۔',
      story: 'پوپو ایک ایسا خنزیر کا بچہ تھا جس کا آہستہ بولنے پر مذاق اڑایا جاتا تھا۔ اسے الفاظ ایک ایسے دوست کی بدولت ملے جو آخر تک اس کے پاس انتظار کرتا رہا، اور اس دن کے جذباتی آنسو آج بھی اسے یاد ہیں۔ اسی لیے پوپو نے ٹھان لیا: جب بھی کوئی بولنا سیکھتے ہوئے لڑکھڑائے، وہ وہی گرمجوشی لوٹائے گا جو اسے کبھی ملی تھی۔ تمہارے مکمل کیے ہوئے ہر جملے پر وہ ہاتھ جوڑ کر سچ مچ متاثر ہو جاتا ہے۔',
    ),
    10: (  // Rara
      summary: 'کبھی نہ تھکنے والی توانائی، جو مسلسل تعریف سے تمہارا اعتماد بھر دیتی ہے۔',
      story: 'رارا ایک خرگوش ہے اور سابق K-pop آئیڈل ٹرینی۔ اسے اسٹیج سے بھی زیادہ پسند کچھ مل گیا: کسی اور کا حوصلہ بڑھانا۔ گلے میں لٹکے ہیڈ فون سے ہر وقت پُرجوش موسیقی بجتی رہتی ہے، اور تمہارا ایک لفظ ہی اسے "کمال!" چیختے ہوئے اچھلنے پر مجبور کر دیتا ہے۔ رارا کی لغت میں "ناکامی" کا لفظ نہیں — صرف "بس تھوڑا رہ گیا" اور "ایک بار اور"۔',
    ),
    11: (  // Dudu
      summary: 'میں بھی الجھ جاتا ہوں — چلو مل کر ڈھونڈتے ہیں۔ دنیا کا سب سے بےفکر پڑھائی کا ساتھی۔',
      story: 'دودو دوپہر کی نیند لیتے لیتے کورین کا استاد بن گیا۔ اس کے اپنے الفاظ میں: "بس ایسے ہی ہو گیا، ہی ہی۔" وہ سست رفتار ہے، کبھی کبھی خود ہی الجھن میں سر کھجاتا ہے؛ پھر بھی عجیب بات ہے کہ دودو کے ساتھ پڑھو تو غلطی کرنا خوفناک نہیں لگتا۔ درست جواب پر وہ یوں حیران ہوتا ہے جیسے جیت اس کی اپنی ہو: "واہ، تمہیں کیسے پتہ چلا؟" نہ جلدی، نہ دباؤ۔',
    ),
  },
  'uz': {
    1: (  // BABA
      summary: 'Har bir xatoni masxara qiladigan o\'tkir tilli ustoz — shunga qaramay, uning shogirdlari eng tez o\'sadi.',
      story: 'Baba daryodagi eng mukammal to\'g\'onni qurgani bilan mashhur edi. Bir kuni sayyoh buzuq koreys tilida yo\'l so\'raganda, u chiday olmay o\'sha yerdayoq talaffuzni tuzatib yubordi. "Shu talaffuz bilan qayerga bormoqchisan?" Uning shafqatsiz darslari haqidagi gap tarqaldi va ajablanarlisi shuki, u tanbeh bergan barcha shogirdlar hayratlanarli darajada yaxshi gapiradigan bo\'lib ketdi. U seni bir marta ham maqtamaydi, ammo taslim bo\'lishingga ham yo\'l qo\'ymaydi.',
    ),
    2: (  // BIBI
      summary: 'To\'g\'ri javob berganingda quvonchdan portlaydi, xato qilganingda esa aql bovar qilmas darajada mehribon bo\'ladi.',
      story: 'Bibi Baba bilan bir daryo bo\'yida o\'sgan. Egizaklardek o\'xshash, ammo fe\'llari mutlaqo qarama-qarshi. Baba noto\'g\'ri tovushdan qah-qah urib kulganda, Bibi yonidagi shogirdni jimgina yupatardi. Biroq Bibida hech kim to\'xtata olmaydigan bir odat bor: sen to\'g\'ri javob bergan lahzada butun daryo eshitadi. To\'g\'on qulay yozgani bir-ikki marta emas. Xato qilganingda dunyodagi eng iliq do\'st, topganingda eng shovqinli muxlis.',
    ),
    9: (  // Popo
      summary: 'Xato qilsang ham hechqisi yo\'q — men doim sening tomoningdaman. Ko\'zi namli, iliq yurakli o\'qituvchi.',
      story: 'Popo sekin gapirgani uchun masxara qilinadigan cho\'chqacha edi. So\'zlarini oxirigacha yonida kutib turgan do\'sti tufayli topdi va o\'sha kungi ta\'sirlanish yoshlarini hanuz eslaydi. Shu bois Popo qaror qildi: kimdir gapirishni o\'rganayotib qoqilsa, o\'zi olgan iliqlikni aynan shundayligicha qaytaradi. Sen tugatgan har bir gapga u ikki qo\'lini qovushtirib, chin dildan ta\'sirlanadi.',
    ),
    10: (  // Rara
      summary: 'Charchashni bilmaydigan quvvat manbai — to\'xtovsiz maqtov bilan ishonchingni qaytadan to\'ldiradi.',
      story: 'Rara — quyon, sobiq K-pop aydol nomzodi. U sahnadan ham ko\'proq yoqadigan narsani topdi: boshqani qo\'llab-quvvatlash. Bo\'ynidagi quloqchindan har doim quvnoq musiqa taraladi va sendan chiqqan bitta so\'zning o\'zi uni "Zo\'r!" deb sakrashga yetadi. Raraning lug\'atida "muvaffaqiyatsizlik" degan so\'z yo\'q — faqat "sal qoldi" va "yana bir marta" bor.',
    ),
    11: (  // Dudu
      summary: 'Men ham chalkashaman — kel, birga topamiz. Dunyodagi eng bosiq o\'quv sherigi.',
      story: 'Dudu tushlik uyqusi paytida koreys tili o\'qituvchisiga aylandi. O\'z so\'zi bilan aytganda: "Qanday bo\'lganini bilmayman, shunday bo\'ldi-qoldi, he-he." U sekin harakat qiladi, ba\'zan chalkashib boshini qashiydigan ham o\'zi; shunga qaramay, Dudu bilan o\'qiganda xato qilish umuman qo\'rqinchli bo\'lmay qoladi. To\'g\'ri topsang, o\'z g\'alabasidek hayratlanadi: "Voy, qayerdan bilding?" Shoshilish ham yo\'q, bosim ham yo\'q.',
    ),
  },
  'vi': {
    1: (  // BABA
      summary: 'Bậc thầy miệng lưỡi sắc bén, chê ngay mỗi lỗi sai — vậy mà học trò lại tiến bộ nhanh nhất.',
      story: 'Baba nổi tiếng với con đập hoàn hảo nhất dòng sông. Một hôm có du khách hỏi đường bằng tiếng Hàn sai bét, cậu không nhịn được mà sửa phát âm ngay tại chỗ. "Phát âm thế mà đòi đi đâu?" Tiếng tăm về những buổi dạy tàn nhẫn lan ra, và lạ thay, mọi học trò bị cậu mắng đều nói tiếng Hàn giỏi đến kinh ngạc. Cậu sẽ không bao giờ khen bạn, nhưng cũng không bao giờ để bạn bỏ cuộc.',
    ),
    2: (  // BIBI
      summary: 'Bùng nổ niềm vui ngay khi bạn nói đúng, và dịu dàng đến khó tin ngay khi bạn sai.',
      story: 'Bibi lớn lên bên cùng dòng sông với Baba. Trông như sinh đôi nhưng tính cách trái ngược hoàn toàn. Khi Baba phá lên cười vì một âm sai, Bibi lặng lẽ vỗ về học trò bên cạnh. Có điều Bibi có một thói quen không ai cản nổi: khoảnh khắc bạn nói đúng, cả dòng sông đều nghe thấy. Con đập suýt sập không chỉ một hai lần. Người bạn ấm áp nhất khi bạn sai, người hâm mộ ồn ào nhất khi bạn đúng.',
    ),
    9: (  // Popo
      summary: 'Sai cũng không sao, tớ luôn ở phía cậu. Người thầy mau nước mắt và ấm lòng.',
      story: 'Popo từng là chú lợn con bị trêu vì nói chậm. Cậu tìm được tiếng nói của mình nhờ một người bạn đã đợi bên cạnh đến tận cùng, và đến giờ vẫn nhớ những giọt nước mắt cảm động ngày ấy. Vì thế Popo quyết định: mỗi khi ai đó vấp ngã trên đường học nói, cậu sẽ trao lại đúng hơi ấm mình từng nhận. Cậu chắp hai tay và thật lòng xúc động với từng câu bạn nói trọn vẹn.',
    ),
    10: (  // Rara
      summary: 'Nguồn năng lượng không biết mệt, nạp đầy tự tin cho bạn bằng những lời khen dồn dập.',
      story: 'Rara là chú thỏ từng là thực tập sinh idol K-pop. Cô tìm thấy điều còn thích hơn cả sân khấu: cổ vũ người khác. Chiếc tai nghe trên cổ lúc nào cũng phát nhạc sôi động, và bạn chỉ cần nói một từ là cô đã nhảy tưng lên hét "Tuyệt vời!". Trong từ điển của Rara không có từ "thất bại" — chỉ có "tiếc quá" và "thêm lần nữa".',
    ),
    11: (  // Dudu
      summary: 'Tớ cũng rối lắm, cùng tìm nhé~ Người bạn học thoải mái nhất trên đời.',
      story: 'Dudu trở thành thầy giáo tiếng Hàn trong lúc đang ngủ trưa. Theo lời cậu: "Tự nhiên thành ra vậy đó, hề hề." Cậu chậm chạp, đôi khi chính cậu mới là người gãi đầu bối rối; vậy mà học cùng Dudu thì việc sai chẳng còn đáng sợ nữa. Bạn trả lời đúng, cậu trầm trồ như thể đó là chiến thắng của mình: "Ồ, sao cậu biết hay vậy?" Không vội vã, không áp lực.',
    ),
  },
  'zh': {
    1: (  // BABA
      summary: '一出错就立刻嘲笑的毒舌大师。奇怪的是，他的学生进步最快。',
      story: '巴巴是河边最会筑坝的海狸。有一天，一位游客用蹩脚的韩语问路，他忍不住当场纠正了对方的发音。"就这个发音你还想去哪儿？"这样开始的毒舌辅导传开了，奇怪的是，被巴巴骂过的学生韩语全都突飞猛进。他死也不会夸你一句，但绝不允许你半途放弃。',
    ),
    2: (  // BIBI
      summary: '答对的瞬间反应爆棚！答错时却温柔得不像话，反差魅力满分。',
      story: '比比是和巴巴在同一条河边长大的海狸。两人长得像双胞胎，性格却完全相反。巴巴对着错误发音大笑时，比比总在旁边安静地安慰学生。不过比比有个谁也拦不住的习惯——学生答对的瞬间，他会用响彻整条河的声音欢呼。水坝差点被震塌的次数不止一两回。答错时是世上最温暖的朋友，答对时是世上最吵的粉丝。',
    ),
    9: (  // Popo
      summary: '错了也没关系，我永远站在你这边。爱哭又暖心的疗愈系老师。',
      story: '波波小时候是个因为说话慢而被取笑的小猪。多亏了一个始终守在身边耐心等待的朋友，他才开了口，那天感动的眼泪他至今仍记得。所以波波下定决心：当有人在学说话时跌倒，他要把自己当年收到的那份温暖原样还回去。你每说完一句话，他都会双手合十，真心为你感动。',
    ),
    10: (  // Rara
      summary: '不知疲倦的人形维他命！用暴风般的称赞帮你充满自信的啦啦队长。',
      story: '拉拉是K-POP偶像练习生出身的兔子。她找到了比舞台更喜欢的事——为别人加油。挂在脖子上的耳机里永远放着轻快的歌，你只要说一句话，她就会喊着"太棒了！"蹦蹦跳跳。拉拉的字典里没有"失败"这个词，只有"好可惜"和"再来一次"。和拉拉在一起，连出错都变成开心的活动。',
    ),
    11: (  // Dudu
      summary: '我也搞不清楚，一起找答案吧～毫无压力、世上最自在的邻家老师。',
      story: '嘟嘟是在午睡时莫名其妙当上韩语老师的。用他自己的话说："不知怎么就这样了，嘿嘿。"他动作慢吞吞，有时自己反而更困惑地挠头，但奇怪的是，和嘟嘟一起学习，出错一点也不可怕。你答对了，他会像自己的事一样由衷感叹："哇，你怎么知道的？"不急不躁，一起懒洋洋地学下去。',
    ),
  },
};

/// The catch-phrase for [characterId] in [locale], or [serverValue] when the
/// app has no override.
///
/// [serverValue] is the response field, so an unmapped character or locale
/// still renders rather than collapsing the slot.
String? characterSummaryFor(int characterId, String? locale, String? serverValue) =>
    _lookup(characterId, locale)?.summary ?? serverValue;

/// The story paragraph for [characterId] in [locale], or [serverValue] when the
/// app has no override.
String? characterStoryFor(int characterId, String? locale, String? serverValue) =>
    _lookup(characterId, locale)?.story ?? serverValue;

/// Resolves [locale] to a language subtag and looks the character up, falling
/// back to English before giving up.
CharacterCopy? _lookup(int characterId, String? locale) {
  final language = _languageOf(locale);
  final exact = _copy[language]?[characterId];
  if (exact != null) return exact;
  // Korean deliberately has no table: falling through here hands Korean users
  // the server value, which is already Korean and always current.
  if (language == 'ko') return null;
  return _copy['en']?[characterId];
}

/// `de_DE` / `de-DE` / `de` → `de`. Null or empty → empty (never matches).
String _languageOf(String? locale) {
  if (locale == null || locale.isEmpty) return '';
  final cut = locale.indexOf(RegExp('[_-]'));
  return (cut == -1 ? locale : locale.substring(0, cut)).toLowerCase();
}
