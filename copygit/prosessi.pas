unit prosessi;

{$mode objfpc}{$H+}
interface
uses riimiuus,riimiutils, Classes, SysUtils,verbikama,nominit,sanataulu;
//var //sanasto:tsanaSTO;//eitait:teitaivu;
procedure teetemput;
var //riimii:triimitin;
  //verbs:tverbit;
  noms:tnominit;
  muuts:tstaulu;  //muissa sanaluokissa kaikki muodot luetellaan listassa, ei generoida


implementation
//uses verbit,nominit;
uses syno;
procedure teetemput;
var   riiminaiheet,riimaavat:tstaulu;sl:tlist;muolist,riilist:tstringlist;syns:tsynonyms;synarr:tsynarray;
begin
  //tmp_num;exit;
  syns:=tsynonyms.create;
  syns.makelist;exit;
  //syns.coocs;exit;
  //syns.gutenberg;exit;
  //syns.luegut;exit; //gutenberg concordance is very low quality. Redo completely .. later! proceed with wiktionary related words & synonyms
  SYNS.read('syns.bin');  // binääri sanat*32 listaa kullekin sanalle liittyvät sanat sanatuus.csv (taivutuskaavat)-järjestysnumeroilla
  writeln('kerrotaan',length(syns.syns)); //
  SYNS.kerro; //lisätään liittyvien liittyvät
  exit;
  syns.list;exit;
  tmp_getnum;exit;
  tmp_num;exit;
  writeln('<li>luo sanasto');
  SANASTO:=tsanasto.create;  //luo myös globaalit verbit, nominit, muodot
  writeln('<li>lue hakusanat',verbikama.vesims[1]);
  riiminaiheet:=tstaulu.create('haku.lst',nil);
  writeln('<h3>//*hae sananumerot perussmuodoille</h3>');
  sl:=riiminaiheet.numeroi;
  muolist:=tstringlist.create;
  riilist:=tstringlist.create;
  writeln('<h3>taivuta->muolist</h3>');
  sanasto.generatelist(sl,muolist);  //taivuttaa kaikki ja laittaa taivutetut sanat muolistiin, sananumerot objekteihin
  writeln('<hr><small>taivutettuja:',muolist.count,'</small>');
  riimaavat:=tstaulu.create('',muolist);
  writeln('<h3>//* riimaa muolist &lt; riimaavat.slista</h3>');
  riimaavat.riimaa;
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

