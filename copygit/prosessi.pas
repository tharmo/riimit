unit prosessi;

{$mode objfpc}{$H+}
interface
uses riimiuus,riimiutils, Classes, SysUtils,verbikama,nominit,sanataulu,ngrams;
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
  getngrams;exit;
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
   sims:tsimmat;
   hlist,glist,glist2:tlist;
   function sltext:string;
   var i:word;
   begin
      result:='';
      for i:=0 to sl.count-1 do result:=result+' '+sans[integer(sl[i])];
      writeln('///',integer(sl[i]),sans[integer(sl[i])]);
   end;
   procedure aho(w:string);
   begin hlist.add(pointer(sans.indexof(w)));
     writeln('///',w,sans.indexof(w));
   end;
begin
  sans:=tstringlist.create;  //pitäis laittaa classiin
  sans.loadfromfile('sanatvaan.ansi');
  //sans.insert(0,'');
  glist:=tlist.create;
  glist2:=tlist.create;
  hlist:=tlist.create;
  //aho(690);
  sans.insert(0,'vaarinhousut');
  //aho('valaista');
  //aho('tulla');
  aho('valaa');
  aho('kala');
  //aho('vala');
  sims:=tsimmat.create(sans.count-1,64,'wvars',sans);
  sims.haegramlist(0,hlist,sans,glist);
  //glist2:=glist;
  sims.haegramlist(0,glist,sans,glist2);
  //exit;
  //writeln('<hr>');
  //for i:=0 to glist2.count-1 do writeln(sans[integer(glist2[i])]);//,integer(glist2[i]));
  //writeln('<hr>');
 // for i:=0 to glist.count-1 do writeln(sans[integer(glist[i])]);//,integer(glist[i]));
  writeln('<hr>');
  //exit;
//!  syns.gutcoocs;//exit;
//!  writeln(sans[0],'<li>createsyns');
  //tmp_num;exit;
  //!  syns:=tsynonyms.create;
  //syns.makelist;writeln('list saved to syn.bin');exit;
  //syns.coocs;exit;
  //syns.gutenberg;exit;
  //syns.luegut;exit; //gutenberg concordance is very low quality. Redo completely .. later! proceed with wiktionary related words & synonyms
 // SYNS.read('synmul.bin');  // binääri sanat*32 listaa kullekin sanalle liittyvät sanat sanatuus.csv (taivutuskaavat)-järjestysnumeroilla
  //SYNS.kerro; //lisätään liittyvien liittyvät
  writeln('<li>luo sanasto');
  SANASTO:=tsanasto.create;  //luo myös globaalit verbit, nominit, muodot
  sanasto.slist:=sans;
  //jostain syystä käyttää tiedostoa NOMSALL.CSV vaikka kaikki on mukana SANATUUS.CSV'ssä.. EI KÄYTÄ
  //******'sanatuus.csv','vmids.csv','vsijat.csv';
  //****  'nomsall.csv','nmids.csv');
  //writeln('<li>lue hakusanat',verbikama.vesims[1]);
//!!  riiminaiheet:=tstaulu.create('haku.lst',nil);  //mitä vittua, vain muutamaa sanaa varten
  //*** SIEMENSANAT TIEDOSTOSTA HAKU.LST
  writeln('<h3>//*hae sananumerot perussmuodoille:</h3>');
//!  sl:=riiminaiheet.numeroi;
//  writeln('<hr><h3>haku:</h3>',sltext,'<hr>');
//!!  syns.haesynolist(sl,sans);
  //writeln('<h3>s1:</h3><hr>',sltext);
//!!    syns.haesynolist(sl,sans);

  //writeln('<h3>s2:</h3><hr>',sltext);
 //! writeln('<h1>gotsyns:',sl.count,'</h1>');
 //! for i:=0 to sl.count-1 do writeln((sans[integer(sl[i])]));
  muolist:=tstringlist.create;

  riilist:=tstringlist.create;
  writeln('<h3>taivuta->muolist',glist2.count,'</h3>');
  sanasto.generatelist(glist2,false);  //taivuttaa kaikki ja laittaa taivutetut sanat muolistiin, sananumerot objekteihin
  //for i:=0 to 10 do writeln('<li>resta:',sanasto.resutaulu.taulu[i].sana,'#',sanasto.resutaulu.taulu[i].sija);
  //writeln('zxczzzzzzzzz');
//EXIT;
  //for i:=0 to muolist.count-1 do try writeln(' ',reversestring(muolist[i]),':',sans[integer(pointer(muolist.objects[i]))],'!!');except writeln('#'); end;
  //for i:=0 to muolist.count-1 do writeln('<sub>',reversestring(muolist[i]),integer(pointer(muolist.objects[i])),'</sub>');exit;
   // writeln('<hr><small>taivutettuja:',muolist.text,'</small>');
   muolist.insert(0,'');
   //riimaavat:=tstaulu.create('',muolist);
   riimaavat:=tstaulu.create('',muolist,sans);
  //exit;
  //riimaavat.listaa;
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

