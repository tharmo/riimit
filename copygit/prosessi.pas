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
procedure teetemput;
var   riiminaiheet:tstaulu;sl:tlist;muolist:tstringlist;
begin
  writeln('<li>luo sanasto');
  SANASTO:=tsanasto.create;  //luo myös globaalit verbit, nominit, muodot
  writeln('<li>lue hakusanat',verbikama.vesims[1]);
  riiminaiheet:=tstaulu.create('haku.lst');

  //riiminaiheet.luohaku;
  writeln('<li>//*etsi numerot');
  sl:=riiminaiheet.numeroi;
  muolist:=tstringlist.create;
  sanasto.expandlist(sl,muolist);
  writeln('<hr>',muolist.text);
  writeln('<li>//*hae synonyymit');
  writeln('<li>//*generoi taivutusmuodot');
  writeln('<li> //* tee hakutaulu');
  writeln('<li>//* riimaa');
  riiminaiheet.riimaa;

  writeln('<li>// ... valitse hyvin riimautuvat sanat, hae niille yhdessä esiintyviä sanoja, niille synonyymeja, generoi muodot, riimitä uudestaan');
  writeln('<li>// .. karsi taas sanoja, hae alkusointuja ja puolisoituja, riimitä uudestaan');
  writeln('<li>// ... sitten lauseiden rakentaminen ja runojalan polkeminen, mutta se lienee ensi vuoden juttuja...');

end;
end.

