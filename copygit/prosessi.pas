unit prosessi;

{$mode objfpc}{$H+}
interface
uses riimiuus,riimiutils, Classes, SysUtils,verbikama,nominit,sanataulu;
//var //sanasto:tsanaSTO;//eitait:teitaivu;
procedure teetemput;
var //riimii:triimitin;
  //verbs:tverbit;
  noms:tnominit;
  //muuts:tstaulu;  //muissa sanaluokissa kaikki muodot luetellaan listassa, ei generoida
procedure teegut;

implementation


//uses verbit,nominit;
uses syno,strutils;

procedure teegut;
var syns:tsynonyms;  I:INTEGER;
begin
  //OR I:=0 TO 16 DO IF I<>809 THEN WRITELN(I,' ',1+(8 - (abs(i-8))) DIV 3);EXIT;
  ngrams;exit;
  syns:=tsynonyms.create;
  // did this at first passa:
  //syns.readgutansi;
  //syns.countguts;
  //syns.gutextract;   exit;
  //syns.gutmatrix;exit;
  syns.gutsparse;
  //syns.gutkerro;

end;


procedure teetemput;
var   riiminaiheet,riimaavat:tstaulu;sl:tlist;muolist,riilist:tstringlist;syns:tsynonyms;synarr:tsynarray;
   i:integer;
   sans:tstringlist;
   function sltext:string;
   var i:word;
   begin
      result:='';
      for i:=0 to sl.count-1 do result:=result+' '+sans[integer(sl[i])];
      writeln('///',integer(sl[i]),sans[integer(sl[i])]);
   end;
begin
  sans:=tstringlist.create;  //pitäis laittaa classiin
  sans.loadfromfile('sanatvaan.ansi');
  writeln(sans[0],'--------------');
  sans.insert(0,'vaarinhousut');
  syns.gutcoocs;//exit;
  writeln(sans[0],'<li>createsyns');
  //tmp_num;exit;
  syns:=tsynonyms.create;
  //syns.makelist;writeln('list saved to syn.bin');exit;
  //syns.coocs;exit;
  //syns.gutenberg;exit;
  //syns.luegut;exit; //gutenberg concordance is very low quality. Redo completely .. later! proceed with wiktionary related words & synonyms
  SYNS.read('synmul.bin');  // binääri sanat*32 listaa kullekin sanalle liittyvät sanat sanatuus.csv (taivutuskaavat)-järjestysnumeroilla
  //syns.list;
  //****** SYNONYYMIT TIEDOSTOSTA SYNMUL.BIN  (Pitää vielä hioa matriisin "kertomista".. myöhemmin)
  //syns.list;exit;
  //writeln('kerrotaan',length(syns.syns)); //
  //SYNS.kerro; //lisätään liittyvien liittyvät
  //syns.list;
  ///***
  {exit;
  syns.list;exit;
  tmp_getnum;exit;
  tmp_num;exit;}
  writeln('<li>luo sanasto');
  SANASTO:=tsanasto.create;  //luo myös globaalit verbit, nominit, muodot
  //jostain syystä käyttää tiedostoa NOMSALL.CSV vaikka kaikki on mukana SANATUUS.CSV'ssä.. EI KÄYTÄ
  //******'sanatuus.csv','vmids.csv','vsijat.csv';
  //****  'nomsall.csv','nmids.csv');
  writeln('<li>lue hakusanat',verbikama.vesims[1]);
  riiminaiheet:=tstaulu.create('haku.lst',nil);  //mitä vittua, vain muutamaa sanaa varten
  //*** SIEMENSANAT TIEDOSTOSTA HAKU.LST
  writeln('<h3>//*hae sananumerot perussmuodoille</h3>');
  sl:=riiminaiheet.numeroi;
  writeln('<hr><h3>haku:</h3>',sltext,'<hr>');
  riiminaiheet.list(sl,sans);
  riiminaiheet.listaa;
  exit;
  syns.haesynolist(sl,sans);
  writeln('<h3>s1:</h3><hr>',sltext);
  syns.haesynolist(sl,sans);
  writeln('<h3>s2:</h3><hr>',sltext);
  writeln('<h1>gotsyns:',sl.count,'</h1>');
  for i:=0 to sl.count-1 do writeln(sans[integer(sl[i])]);
  muolist:=tstringlist.create;

  riilist:=tstringlist.create;
  writeln('<h3>taivuta->muolist</h3>');
  sanasto.generatelist(sl,muolist);  //taivuttaa kaikki ja laittaa taivutetut sanat muolistiin, sananumerot objekteihin
  writeln('<hr><small>taivutettuja:',muolist.count,'</small>');
  riimaavat:=tstaulu.create('',muolist);
  //tstaulu on otus joka sisältää trien sanoista (vs. lemma) joiden keskenäisiä riimejä haetaan. Myös taipumattomat sanat (adverbit yms) hoidetaan tstauluna.
  writeln('<h3>//* riimaa muolist &lt; riimaavat.slista</h3>');
  riimaavat.riimaa;  //hae keskenäiset riimit
  //writeln('<h3>riimattu > miköä vitun riilista=</h3>');
  //writeln('<hr>',riilist.text);
  writeln('<li>//*hae synonyymit');
  writeln('<li>//*generoi taivutusmuodot');
  writeln('<li> //* tee hakutaulu');

  writeln('<li>// ... valitse hyvin riimautuvat sanat, hae niille yhdessä esiintyviä sanoja, niille synonyymeja, generoi muodot, riimitä uudestaan');
  writeln('<li>// .. karsi taas sanoja, hae alkusointuja ja puolisoituja, riimitä uudestaan');
  writeln('<li>// ... sitten lauseiden rakentaminen ja runojalan polkeminen, mutta se lienee ensi vuoden juttuja...');

end;
end.

