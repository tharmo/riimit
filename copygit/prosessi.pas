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
procedure tmp_getnum;
var binfile:file;i,j:integer;
  synarray:array[0..27550] of array[0..31] of word;
  slist:tstringlist;
begin
  slist:=tstringlist.create;
  slist.loadfromfile('sanatuus.ansi');
  AssignFile(binfile, 'syns.bin');
  try
      Reset(binfile, sizeof(synarray));
      Blockread(binfile, synarray, 1);
      for i:=0 to 27550 do
      if synarray[i,0]=0 then continue
      else
      begin
          writeln('<li>',i, copy(slist[synarray[i,0]],length(slist[synarray[i,0]])-10),':');
         for j:=0 to 31 do
         if synarray[i,j]=0 then break
          else writeln(copy(slist[synarray[i,j]],length(slist[synarray[i,j]])-10));
        end;
    except writeln('failuuuri');end;
end;

procedure tmp_num;
var ifile,synfile,resfile:textfile;i,j,w,max1,max2,max3:integer;slist,linelist,reslist:tstringlist;rivi,sana:ansistring;
  posi,psan,hits:integer;
  synarray:array[0..27550] of array[0..31] of word;
  binfile:file;
begin
  slist:=tstringlist.create;
  reslist:=tstringlist.create;
  linelist:=tstringlist.create;
  //linelist.StrictDelimiter:=true;
  linelist.Delimiter:=' ';
  assign(ifile,'sanatuus.ansi');  //synonyymit/liittyvät sanat
  reset(ifile);
  assign(resfile,'sanatnum.ansi');  //synonyymit/liittyvät sanat
  rewrite(resfile);
  assign(synfile,'syn_ok.ansi');  //synonyymit/liittyvät sanat
  reset(synfile);
  fillchar(synarray, sizeof(synarray),0);
  i:=0;
  while not eof(ifile) do
  begin
   i:=i+1;
   //writeln(i);
   readln(ifile,rivi);
   linelist.delimitedtext:=rivi;
   //for j:=0 to linelist.count-1 do writeln(j,'/',linelist[j]);
   reslist.add(trim(linelist[1]));
  end;
  //writeln('<li>',reslist.indexof('haarukka'),reslist.Text);exit;
  i:=0;
  close(ifile);
  linelist.Delimiter:=',';
  max1:=0;
  while not eof(synfile) do
  begin
   i:=i+1;
   //if i>1000 then break;
   readln(synfile,rivi);
   //writeln('<li>',i,':');
   linelist.delimitedtext:=rivi;
   //writeln(i,linelist[0]);
   if max1<linelist.count then max1:=linelist.count;
   //if linelist.count>31 then writeln('<li>',linelist.count,' ',rivi);
   hits:=0;
   psan:=reslist.indexof(linelist[0]);
   if psan>0 then  //pitäis saada talteen myös tieto synonyymien keskinäisistä yhteyksistä
   begin
    writeln(resfile);
   for j:=0 to linelist.count-2 do
   begin
        sana:=linelist[j];
        posi:=reslist.indexof(sana);
        if posi>0 then //writeln('/',sana,posi)
        begin
          synarray[psan,hits]:=posi;
          write(resfile,sana,',',posi);
          hits:=hits+1;
        end;
   end
   end else
   begin
     writeln('<li>',linelist[0],':');
     for j:=1 to linelist.count-2 do
     begin
      sana:=linelist[j];
      posi:=reslist.indexof(sana);
      if posi>0 then writeln(sana) else writeln('-');
     end;
   end;
  end;
  writeln('<h1>max:',max1,'</h1>');
  writeln('<h1>binsize:',sizeof(synarray),'</h1>');
  AssignFile(binfile, 'syns.bin');
      try
        ReWrite(binfile, sizeof(synarray));
        BlockWrite(binfile, synarray, 1);
      finally
        writeln('binsaved');
        CloseFile(binfile);end;
  for i:=9990 to 10000 do
  begin
    w:=random(27000);
    sana:=reslist[w];
    posi:=reslist.indexof(sana);
    //writeln('<li>',sana,'/',w,'/',posi);
  end;
  close(resfile);

 end;
//uses verbit,nominit;
procedure teetemput;
var   riiminaiheet,riimaavat:tstaulu;sl:tlist;muolist,riilist:tstringlist;
begin
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

