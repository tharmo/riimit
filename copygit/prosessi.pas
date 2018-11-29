unit prosessi;

{$mode objfpc}{$H+}
interface
uses riimiuus,riimiutils, Classes, SysUtils,verbikama,nominit,sanataulu,ngrams,math;
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
   i,siz:integer;
   sans:tstringlist;
   sims:tsimmat;
   hlist,hplist,glist,glist2,gplist,gplist2:tlist;
   function sltext:string;
   var i:word;
   begin
      result:='';
      for i:=0 to sl.count-1 do result:=result+' '+sans[integer(sl[i])];
      writeln('///',integer(sl[i]),sans[integer(sl[i])]);
   end;
   procedure aho(w:string);
   begin hlist.add(pointer(sans.indexof(w)));
       hplist.add(pointer(10));
     writeln('///',w,sans.indexof(w));
   end;
begin
  sans:=tstringlist.create;  //pitäis laittaa classiin
  sans.loadfromfile('sanatvaan.ansi');
  //sans.insert(0,'');
  glist:=tlist.create;
  glist2:=tlist.create;
  gplist:=tlist.create;
  gplist2:=tlist.create;
  hplist:=tlist.create;
  hlist:=tlist.create;
  //aho(690);
  sans.insert(0,'vaarinhousut');
  aho('sauna');
  aho('kiuas');
  aho('laude');
  aho('löyly');
  aho('kuuma');
  aho('helvetti');
  aho('nautinto');
  aho('autuus');
  aho('olut');
  aho('kärsimys');
  aho('pätsi');
  {aho('helvetti');
  aho('kärsimys');
  aho('nauttia');
  aho('helvetti');
  aho('kärsimys');
  aho('synti');
    aho('ihana');
  aho('nautinto');
  aho('palella');
  aho('jää');
  //aho('maksaa');
  aho('sauna');
  aho('kuolla');
  aho('nauttia');
  aho('pakkanen');
  aho('kuuma');
  aho('helvetti');
  aho('ikuinen');
  aho('autuus');
  aho('tuska');
  Aho('löyly');
  aho('kiuas');
  aho('alaston');
  //aho('kaunis');

  //aho('kasvo');
  //aho('kasvi');
  //aho('kasvaa');
  //aho('kissa');
  //aho('pissa');
  //aho('tähti');
  }
 // sims:=tsimmat.create(sans.count-1,64,'wvars',sans);
 // sims:=tsimmat.create(sans.count-1,64,'wvars',sans);
  sims:=tsimmat.create(27550,64,'wvars1',sans);
  //sims.kerro(64,glist2,sans,nil);  exit;
  //listgrams;
  //sims:=tsimmat.create(27550,64,'wvars',sans);
{  writeln('<hr>garmlöist');
  sims.haegramlist(64,hlist,hplist,sans,glist,gplist);
  //sims.list(sans);
  for i:=0 to glist.count-1 do writeln('>',sans[integer(glist[i])],integer(gplist[i]));//,integer(glist2[i]));
  writeln('<<hr>tuttuja:',glist.count,'/',gplist.count);
}  //glist2:=glist;
{  sims.haegramlist(16,glist,gplist,sans,glist2,gplist2);
  writeln('<<hr>tututuu:',glist2.count,'/',gplist2.count);
  for i:=0 to glist2.count-1 do writeln('+',sans[integer(glist2[i])],integer(gplist2[i]));
}  if 1=0 then
  for i:=0 to glist2.count-1 do
  begin
      siz:=integer(gplist2[i]);
      if siz>10 then
      writeln('|<b style="color:red;font-size:',min(8,siz div 200),'em;margin:-4em;margin-left:0em;opacity:0.5">',sans[integer(glist2[i])],'</b>') //,integer(glist2[i]));
      else  if siz>5 then
        writeln('<em style="font-size:',min(80,max(12,siz div 5)),'px;">',sans[integer(glist2[i])],'</em>') //,integer(glist2[i]));
      {else if integer(gplist2[i])>100 then
      writeln('|<b style="color:green;font-size:',siz div 100,'em">',sans[integer(glist2[i])],siz,'</b>') //,integer(glist2[i]));
      else if siz>50 then
      writeln('|<b>',sans[integer(glist2[i])],siz,'</b>') //,integer(glist2[i]));
      else if integer(gplist2[i])>0 then
      writeln('|',sans[integer(glist2[i])],siz);//,integer(glist2[i]));}
  end;
  //exit;
  //sims.list(sans);
  writeln('<hr>tutuntuttuja:',hlist.count);
  //glist.clear;gplist.clear;
  sims.kerro(64,hlist,hplist,sans,hlist,hplist);
  //GLIST:=GLIST2;gplist2:=gplist;
  writeln('<hr>');
  //for i:=0 to glist.count-1 do if integer(gplist[i])>10 then writeln('&lt;',sans[integer(glist[i])],integer(gplist[i]));//,integer(glist2[i]));
  writeln('<hr>');
  exit;
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
  //muolist:=tstringlist.create;

  riilist:=tstringlist.create;
  writeln('<h3>generatelist:',glist.count,'</h3>');
  sanasto.generatelist(glist,false);  //taivuttaa kaikki ja laittaa taivutetut sanat muolistiin, sananumerot objekteihin
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

