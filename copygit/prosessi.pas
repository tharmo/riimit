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
  sans:=tstringlist.create;  //pit�is laittaa classiin
  sans.loadfromfile('sanatvaan.ansi');
  //sans.insert(0,'');
  glist:=tlist.create;
  glist2:=tlist.create;
  hlist:=tlist.create;
  //aho(690);
  sans.insert(0,'vaarinhousut');
  aho('sauna');
  aho('olut');
  aho('tuska');
  aho('l�yly');
  aho('ihana');
  aho('nautinto');
  aho('palella');
  aho('j��');
  //aho('maksaa');}
  {aho('helvetti');
  aho('sauna');
  aho('k�rsimys');
  aho('nauttia');
  aho('kuolla');
  aho('nauttia');
  aho('pakkanen');
  aho('kuuma');
  aho('helvetti');
  aho('ikuinen');
  aho('autuus');
  aho('tuska');
  Aho('l�yly');
  aho('kiuas');
  aho('alaston');
  //aho('kaunis');

  //aho('kasvo');
  //aho('kasvi');
  //aho('kasvaa');
  //aho('kissa');
  //aho('pissa');
  //aho('t�hti');
  }
 // sims:=tsimmat.create(sans.count-1,64,'wvars',sans);
 // sims:=tsimmat.create(sans.count-1,64,'wvars',sans);
  sims:=tsimmat.create(27550,64,'wvars1',sans);
  //sims.kerro(64,glist2,sans,nil);  exit;
  //listgrams;
  //sims:=tsimmat.create(27550,64,'wvars',sans);
  sims.haegramlist(16,hlist,sans,glist);
  //sims.list(sans);
  writeln('<<hr>tuttuja:',glist.count);
  //glist2:=glist;
  sims.haegramlist(16,glist,sans,glist2);
  writeln('<hr>tutuntuttuja:',glist2.count);
  glist.clear;
  sims.kerro(64,glist2,sans,glist);
  //GLIST2:=GLIST;
  //writeln('<hr>');
  for i:=0 to glist2.count-1 do writeln('>',sans[integer(glist2[i])]);//,integer(glist2[i]));
  //writeln('<hr>');
 // for i:=0 to glist.count-1 do writeln(sans[integer(glist[i])]);//,integer(glist[i]));
  writeln('<hr>');
//!  syns.gutcoocs;//exit;
//!  writeln(sans[0],'<li>createsyns');
  //tmp_num;exit;
  //!  syns:=tsynonyms.create;
  //syns.makelist;writeln('list saved to syn.bin');exit;
  //syns.coocs;exit;
  //syns.gutenberg;exit;
  //syns.luegut;exit; //gutenberg concordance is very low quality. Redo completely .. later! proceed with wiktionary related words & synonyms
 // SYNS.read('synmul.bin');  // bin��ri sanat*32 listaa kullekin sanalle liittyv�t sanat sanatuus.csv (taivutuskaavat)-j�rjestysnumeroilla
  //SYNS.kerro; //lis�t��n liittyvien liittyv�t
  writeln('<li>luo sanasto');
  SANASTO:=tsanasto.create;  //luo my�s globaalit verbit, nominit, muodot
  sanasto.slist:=sans;
  //jostain syyst� k�ytt�� tiedostoa NOMSALL.CSV vaikka kaikki on mukana SANATUUS.CSV'ss�.. EI K�YT�
  //******'sanatuus.csv','vmids.csv','vsijat.csv';
  //****  'nomsall.csv','nmids.csv');
  //writeln('<li>lue hakusanat',verbikama.vesims[1]);
//!!  riiminaiheet:=tstaulu.create('haku.lst',nil);  //mit� vittua, vain muutamaa sanaa varten
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
  //muolist:=tstringlist.create;

  riilist:=tstringlist.create;
  writeln('<h3>generatelist:',glist2.count,'</h3>');
  sanasto.generatelist(glist2,false);  //taivuttaa kaikki ja laittaa taivutetut sanat muolistiin, sananumerot objekteihin
  writeln('<li>got:',sanasto.resutaulu.wcount);
  //sanasto.addtolist('koskaan');
  //for i:=0 to sanasto.resutaulu.wcount-1 do writeln('<li>resta:',reversestring(sanasto.resutaulu.taulu[i].sana),'#',sanasto.resutaulu.taulu[i].sija);
  //writeln('zxczzzzzzzzz');
  //EXIT;
  //for i:=0 to muolist.count-1 do try writeln(' ',reversestring(muolist[i]),':',sans[integer(pointer(muolist.objects[i]))],'!!');except writeln('#'); end;
  //for i:=0 to muolist.count-1 do writeln('<sub>',reversestring(muolist[i]),integer(pointer(muolist.objects[i])),'</sub>');exit;
   // writeln('<hr><small>taivutettuja:',muolist.text,'</small>');
   //muolist.insert(0,'');
   //riimaavat:=tstaulu.create('',muolist);
   riimaavat:=tstaulu.create('',muolist,sans);
  //riimaavat.listaa;
  //tstaulu on otus joka sis�lt�� trien sanoista (vs. lemma) joiden kesken�isi� riimej� haetaan. My�s taipumattomat sanat (adverbit yms) hoidetaan tstauluna.
  writeln('<h3>//* riimaa muolist &lt; riimaavat.slista</h3>');
  riimaavat.riimaa;  //hae kesken�iset riimit
  //writeln('<h3>riimattu > mik�� vitun riilista=</h3>');
  //writeln('<hr>',riilist.text);
  writeln('<li>//*hae synonyymit');
  writeln('<li>//*generoi taivutusmuodot');
  writeln('<li> //* tee hakutaulu');

  writeln('<li>// ... valitse hyvin riimautuvat sanat, hae niille yhdess� esiintyvi� sanoja, niille synonyymeja, generoi muodot, riimit� uudestaan');
  writeln('<li>// .. karsi taas sanoja, hae alkusointuja ja puolisoituja, riimit� uudestaan');
  writeln('<li>// ... sitten lauseiden rakentaminen ja runojalan polkeminen, mutta se lienee ensi vuoden juttuja...');

end;
end.

