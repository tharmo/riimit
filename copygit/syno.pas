unit syno;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;
 type tsynarray=array of word;
   const synsans=27550;syncols=32;
type tsynonyms=class(tobject)
 syns:tsynarray;
 slist:tstringlist;
procedure kerro;
procedure list;
function read(fn:string):boolean;
procedure gutenberg;
procedure luegut;
procedure teegut;
procedure gutcoocs;
function asyn(r,c:word):word;
procedure setsyn(sa,sy:word);
procedure delsyn(sa,sy:word);
function overlaps(s1,s2:word;var isin:boolean):word;
//function isrel(s1,s2:word):word;
procedure makelist;
procedure readgutansi;
procedure countguts;
procedure gutscarse;
procedure gutextract;
procedure gutmatrix;
function haesyno(sanum:word;var res:tlist;sl:tstringlist):integer;
function haesynolist(var sanums:tlist;sl:tstringlist):word;
end;


procedure tmp_getnum;
procedure tmp_num;

implementation
 uses math,riimiutils;
type tgutcc=array of word;
  tagut=array[0..15] of word;
type  tgutw=array of word;


  function tsynonyms.haesynolist(var sanums:tlist;sl:tstringlist):word;
  var i,j,seeds:integer;
  begin
    seeds:=sanums.count;
    for i:=0 to seeds-1 do
    begin
      //sanums.add(pointer(
      writeln('<li><b>',sl[integer(sanums[i])],'</b>:');
      haesyno(integer(sanums[i])-1,sanums,sl);
      //writeln('%',sanums.count,sanums.count-1]));
    end;
  end;
  function tsynonyms.haesyno(sanum:word;var res:tlist;sl:tstringlist):integer;
  var i,j:integer;
  begin
    for i:=0 to syncols-1 do
    if syns[sanum*(syncols)+i]=0 then break
    else begin
     result:=syns[sanum*(syncols)+i];
     res.add(pointer(result+1));
     writeln(',','#',sl[result+1],'/');
    end;
  end;

function tsynonyms.asyn(r,c:word):word;
begin
   result:=syns[r*(syncols)+c];
end;
procedure tsynonyms.setsyn(sa,sy:word);
vaR HIT:WORD;
begin
   try
   //writeln('lisää ', sy, 'sanan ', sa,' listaan (' ,length(syns));
   FOR hit:=0 TO SYNCOLS-1 DO
   IF asyn(sa,hit)<>0 then
   begin  //etsitään eka vapaa paikka. Jos oli valmiiksi, keskeytetään
     if asyn(sa,hit)=sy then break else continue
   end
   else begin
       syns[sa*(syncols)+hit]:=sy;//writeln('<sub>',slist[sa],'+',slist[sy],'</sub>');
       break;
   end;
   except writeln('zzzzzzzzzzzzzzzzzzzzz');end;
end;

procedure tsynonyms.delsyn(sa,sy:word);
vaR HIT:WORD;
begin
   //writeln('lisää ', sy, 'sanan ', sa,' listaan (' ,length(syns));
   FOR hit:=0 TO SYNCOLS-1 DO
   begin
     IF asyn(sa,hit)=0 then break;
     if asyn(sa,hit)=sy then
     begin
       move(syns[sa*(syncols)+hit+1],syns[sa*(syncols)+hit],(syncols-hit-1)*2);//writeln('<sub>',slist[sa],'+',slist[sy],'</sub>');
       break;
     end;
   end;
end;
function tsynonyms.overlaps(s1,s2:word;var isin:boolean):word;
var i,j,k,myi:word;
begin
   isin:=false;
   result:=0;
  for i:=0 to syncols-1 do
  begin
     myi:=asyn(s1,i);
     if myi=s2 then isin:=true;
     if myi=0 then break else
     begin
      for j:=0 to syncols-1 do  if asyn(s2,j)=0 then break else
      if myi=asyn(s2,j) then //result:=result+1;
      begin result:=result+1;//writeln('<sup>',slist[s2],':',slist[myi],'</sup>');
      end;

     end;
   end;

end;
procedure tsynonyms.teegut; //lue .gutenbergin tuottama binääri
var ccfile,gutf,outf:textfile;
  gutlist,guttmp:tstringlist;i,j,spos,occurs:integer;
  nn:word;
  s1,s2,line,pline:ansistring;ch:char; sn1,sn2:integer;
  gutbin:file;
  gutcc:tgutcc;//array[0..573] of array[0..5730] of byte;
  gutarr:tgutw; agut:array[0..15] of word;//tagut;
  achar:ansichar;
  // cc:array of word:
begin
     assign(ccfile,'gutpairs.lst');
     reset(ccfile);
     while not eof(ccfile) do
     begin

     end;
      setlength(gutcc,5730*5730*2);
      setlength(gutarr,5730*16);
      AssignFile(gutbin, 'gutcc.bin');  //ei onnistu tstrinlistillä varmaan blockwrite
        writeln('ass');
        Reset(gutbin, length(gutarr));
        //Reset(gutbin, 16);//length(agut));
        Blockread(gutbin, gutarr[0], 1);
        writeln('reset');
        writeln('read',length(gutarr));
        slist:=tstringlist.create;
        gutlist:=tstringlist.create;
        slist.loadfromfile('sanatvaan.ansi');
        //slist.loadfromfile('gutsanat.ansi');
        writeln('luettugutbin',length(gutarr));
        {for i:=0 to 5729 do  //LISTY
        begin
           //Blockread(gutbin, agut, 1);
            move(gutarr[i*16],nn,2);
            // move(agut[0],nn,2);
            try
            writeln('<li>',i,' ',nn,slist[nn],' ');
            except writeln('fail',nn);end;
             for j:=2 to 15 do if gutarr[i*16+j]<>0 then write(ansichar(gutarr[i*16+j])) else break;
        end;]}
        closefile(gutbin);

end;

procedure tsynonyms.luegut; //lue .gutenbergin tuottama binääri
var ccfile,gutf,outf:textfile;
  gutlist,guttmp:tstringlist;i,j,spos,occurs:integer;
  nn:word;
  s1,s2,line,pline:ansistring;ch:char; sn1,sn2:integer;
  gutbin:file;
  gutcc:tgutcc;//array[0..573] of array[0..5730] of byte;
  gutarr:tgutw; agut:array[0..15] of word;//tagut;
  achar:ansichar;
  // cc:array of word:
begin
      setlength(gutcc,5730*5730*2);
      setlength(gutarr,5730*16);
      AssignFile(gutbin, 'guttext.bin');  //ei onnistu tstrinlistillä varmaan blockwrite
        writeln('ass');
        Reset(gutbin, length(gutarr));
        //Reset(gutbin, 16);//length(agut));
        Blockread(gutbin, gutarr[0], 1);
        writeln('reset');
        writeln('read',length(gutarr));
        slist:=tstringlist.create;
        gutlist:=tstringlist.create;
        slist.loadfromfile('sanatvaan.ansi');
        //slist.loadfromfile('gutsanat.ansi');
        writeln('luettugutbin',length(gutarr));
        {for i:=0 to 5729 do  //LISTY
        begin
           //Blockread(gutbin, agut, 1);
            move(gutarr[i*16],nn,2);
            // move(agut[0],nn,2);
            try
            writeln('<li>',i,' ',nn,slist[nn],' ');
            except writeln('fail',nn);end;
             for j:=2 to 15 do if gutarr[i*16+j]<>0 then write(ansichar(gutarr[i*16+j])) else break;
        end;]}
        closefile(gutbin);

end;
procedure tsynonyms.gutenberg;
var gutf,outf:textfile;
    gutlist,guttmp:tstringlist;i,j,nn,spos,occurs:integer;
  s1,s2,line,pline:ansistring;ch:char; sn1,sn2:integer;
  gutbin:file;
  hits:word;
  gutcc:tgutcc;//array[0..573] of array[0..5730] of byte;
  gutarr:tgutw; agut:tagut;achar:ansichar;
begin
  //setlength(gutcc,5730*5730*2);
  setlength(gutarr,5730*16);
   writeln('gutenbegin konkordanssi',length(gutarr));
  slist:=tstringlist.create;
  gutlist:=tstringlist.create;
  guttmp:=tstringlist.create;
  slist.loadfromfile('sanatvaan.ansi');
  //guttmp.loadfromfile('gut_con1.tmp');
  //guttmp.sort;
  //writeln(gutlist.text);exit;
  gutlist.sorted:=true;
  hits:=0;
  for i:=0 to guttmp.count-1 do
  begin
    nn:=slist.indexof(guttmp[i]);
    if nn<0 then continue;
    gutlist.addobject(guttmp[i],tobject(pointer(nn)));
    //if length(guttmp[i])>14 then
    //if i>10 then break;
    //writeln('<li>',slist[nn],'/',guttmp[i],length(guttmp[i]),':');
    for j:=1 to min(14,length(guttmp[i])) do begin gutarr[hits*16+(j+1)]:=byte(guttmp[i][j]);end;
    // gutarr[i][0]:=nn;
    move(nn,gutarr[hits*16],2);
    hits:=hits+1;
    //for j:=2 to 15 do writeln(j,ansichar(gutarr[i][j]));
  end;
  writeln('<hr>gutlist;',hits,' ',nn,' ',gutlist.count,'</hr>');
  // exit;

  try
  finally
    try
    //close(outf);close(gutf)
        gutlist.savetofile('gutsanat.ansi');
        writeln('finallyy',length(gutarr));
        AssignFile(gutbin, 'guttext.bin');  //ei onnistu tstrinlistillä varmaan blockwrite
        writeln('ass');
        Rewrite(gutbin, length(gutarr));
        writeln('reset');
        Blockwrite(gutbin, gutarr[0], 1);
        writeln('wrote ',length(gutarr));
        closefile(gutbin);

        writeln('<li>luettu');


    except writeln('jotain mätti',length(gutarr),'!!!');end;
    for i:=0 to 5729 do
    begin
        move(gutarr[i*16],nn,2);
        try
        writeln('<li>',i,' ',nn,slist[nn],' ');
        except writeln('fail',nn);end;
        //slist[nn],':');
         //if length(guttmp[i])>14 then
         //writeln('<li>',guttmp[i],length(guttmp[i]));
         for j:=2 to 15 do if gutarr[i*16+j]<>0 then write(ansichar(gutarr[i*16+j])) else break;
    end;
  end;
end;
function tsynonyms.read(fn:string):boolean;
var synos2:array of  word;binfile:file;
begin
  writeln('<li>lue:');
 setlength(syns,synsans*syncols*2);
 AssignFile(binfile, fn);
 try
     Reset(binfile, length(syns));
     Blockread(binfile, syns[0], 1);
     closefile(binfile);
     writeln('<li>luettu');
 except writeln('failreadsyns');end;
 //list;
end;
procedure tsynonyms.list;
var i,j:word;//slist:tstringlist;
begin
  writeln('<li>list:',length(syns));
  slist:=tstringlist.create;
  slist.loadfromfile('sanatvaan.ansi');
  //writeln('nonllanolla',syns[0],' 0:0 ok');
      for i:=0 to slist.count-1 do
      //if asyn(i,0)=0 then continue      else
      begin
          writeln('<li>',i,slist[i]);//, copy(slist[synarray[i,0]],length(slist[synarray[i,0]])-10),':');
          //break;
         for j:=0 to 31 do
         if asyn(i,j)=0 then break
          else writeln(slist[asyn(i,j)]);
        end;
end;

procedure tsynonyms.kerro;
vAR times,i,j,k,myj,myk,OLAPj,olapk,olaps:integer;isrel:boolean;toadds:array[0..31] of word;added:word;
   x:integer;
   procedure addadd(sa:word);  var ii,dd:integer;
   begin
     if added>=31 then exit;
             for dd:=0 to added do
             if dd=added then
             begin
               toadds[added]:=sa;added:=added+1;
               //writeln(slist[i],'+',slist[sa]);
            end else  if toadds[dd]=sa then break; //was already

   end;
 var sssi,sssj,sssk:word;
begin
  writeln('<li>sparcemat mult:',synsans);
  slist:=tstringlist.create;
  slist.loadfromfile('sanatvaan.ansi');
  //readsyno('sanatuus.ansi',syns);
  writeln(slist.count);
  if 1=0 then for i:=0 to slist.count-1 do
  begin
    writeln('<li>',slist[i],':',i,':');
    for j:=0 to syncols do begin x:=asyn(i,j);if x<1 then break else writeln(slist[x]);end;
  end;
  if 1=0 then for i:=0 to slist.count-1 do
  begin
    writeln('<li>',slist[i],':');
    for j:=0 to syncols do
    begin
       olaps:=0;
       myj:=asyn(i,j); if myj=0 then break else writeln(slist[myj]);
       for k:=1 to syncols-1 do if asyn(myj,k)=0 then break
       else olaps:=olaps+overlaps(asyn(myj,k),myj,isrel);
       writeln(olaps);
    end;
  end;
  for times:=1 to 1 do
  begin
     try
    for i:=0 to synsans-1 do
    //for i:=4912 to 4920 do
    begin
     // writeln(i);
      for j:=0 to syncols-1 do if asyn(i,j)=0 then break else sssi:=j+1;
      fillchar(toadds,sizeof(toadds),0);  //sepoarate for each word. could make it after a whole round of times instead;
      added:=0;
      //if i=16077 then writeln('<li><b>XYZ:',slist[i],sssi,slist[myj],'</b>');
      //if i>7000 then break;
      //if i<slist.count then writeln('<b>',slist[i],'</b>:');
      try
      for j:=0 to syncols-1 do
      begin
       for k:=0 to syncols-2 do if asyn(j,k)=0 then break else sssj:=k+1;
        myj:=asyn(i,j);
        //if i=16077 then writeln('<li><b>XYZ:',slist[i],sssi,slist[myj],'</b>');
        if myj=0 then break;
        //writeln('.');
        //writeln(slist[myj]);
        OLAPj:=overlaps(i,myj,isrel);
        olapk:=0;olaps:=olapj;
        //if not isrel then addadd(myj);
        //if olapj<1 then begin  writeln('<span style="color:red">',slist[i],'-',slist[myj],'</span>');end;
        //if olapj<3 then begin   writeln('');continue;end;//<span style="color:red">',slist[i],'-',slist[myj],'</span>');end;
        //if olapj>1 then
        for k:=0 to syncols-1 do
        begin
           myk:=asyn(myj,k);
          //if i=16077 then writeln('<li><b>KK:',slist[myj],sssi,slist[myk],'</b>');
          if myk=i then continue;
          if myk=0 then break;
          //IF isrel(i,myk) then break;
          OLAPk:=overlaps(i,myk,isrel);
          if (olapk>0) or (isrel) then olaps:=olaps+1;
          if isrel then continue;
          //writeln('<em style="color:',ifs(olap>1,'green','red'),'">',slist[myk],'</em>:');
          if olapk>2 then
          begin
             addadd(myk);
             //else
          end
          else if  sssi=1 then begin addadd(myk);end;//writeln('<b>',slist[i]+'>'+slist[myj]+'+'+slist[myk],'</b>');end;
          //if i=16077 then writeln('<li><b>XXX',slist[i]+'>'+slist[myj]+'+'+slist[myk],'</b>');
          //setsyn(i,myk);
        end;
        //if olaps<1 then writeln('<span style="color:red">',slist[i],'-',slist[myj],'</span>')

       //setsyn(syns[i,j],syns[i,1]);

      end;
      except writeln('!!!?');end;
      for j:=0 to added do begin setsyn(i,toadds[j]);setsyn(toadds[j],i);
      end;
    end;
     except writeln('!!!?');end;
    WRITELN('<HR>Uusi KIERROS:',times+1,'<BR>');
   END;
  for i:=99990 to slist.count-1 do
  begin
  writeln('<li><b>',slist[i],'</b>:');
  for j:=0 to syncols-1 do
    begin
       olaps:=0;
       myj:=asyn(i,j); if myj=0 then break else writeln(slist[myj]);
       for k:=0 to syncols-1 do if asyn(myj,k)=0 then break
       else olaps:=olaps+overlaps(asyn(myj,k),myj,isrel);
       writeln(olaps);
    end;
  //writeln('<li>del first:');
  //delsyn(i,asyn(i ,1));
  //for j:=0 to syncols do begin myj:=asyn(i,j); if myj=0 then break else writeln(slist[myj]);end;
 end;
  savebin(synsans,syncols,syns,'synmul2.bin');


end;

procedure big16(var tosort,bigs:pword;bigvals:pword;w:word;sl:tstringlist);
var i,j,posi,fils:word;d:boolean;
begin
  //exit;
  //d:=false;//w=21;
 //if d then writeln('+++',word((tosort)^),sl[w],'<hr>');
 fillchar(bigs^,32,0);
 fillchar(bigvals^,32,0);
 //if d then for i:=0 to 50 do if (tosort+i)^>0 then writeln(i,sl[i],' <b>',i,'=',(tosort+i)^,'</b>');// else writeln(sl[i]);

 for i:=0 to 5730 do
 begin
   posi:=15;//fils:=0;
   if (tosort+i)^>0 then //(bigvals+10)^ then
   begin
   //writeln('<li>',i,sl[i],' <b>',i,'=',(tosort+i)^,'</b>');
   for j:=0 to 15 do
    begin
     //if d then writeln(' /',j,'.',(bigvals+j)^,'/ ');//,(tosort+i)^>(bigvals+j)^);
     if (tosort+i)^>(bigvals+j)^ then begin //if d then writeln(j,'.',(bigs+j)^);
       posi:=j;break;end;
    end;
   end;
   if posi<15 then
   begin
    fils:=fils+1;
    move((bigs+posi)^,(bigs+posi+1)^,(15-posi));
    move((bigvals+posi)^,(bigvals+posi+1)^,(15-posi));
    move(i,(bigs+posi)^,2);
    move((tosort+i)^,(bigvals+posi)^,2);
   end;
 end;
 // for j:=0 to 15 do    writeln('///<b>',word((bigs+j)^),'=',word((bigvals+j)^),'</b>');

end;

procedure tsynonyms.gutextract;
var gutf,outf:textfile;i:longword;j,occurs:integer;s:string[15];
   //ss:array[0..32] of string[23];
    got:word;
    ss,gutlist:tstringlist;
    wnum:word;//integer;
    ostr:tfilestream;
    pw:pword;

begin
  pw:=@wnum;
    gutlist:=tstringlist.create;
   gutlist.sorted:=true;
   gutlist.loadfromfile('gutsanat.ansi');
   ostr:=TFileStream.Create('gutnums.bin', fmcreate or  fmShareExclusive);
    try
   ss:=tstringlist.create;
    assign(gutf,'isogut.lst');
    reset(gutf);
    assignfile(outf,'isogut.coc');
    rewrite(outf);
    got:=0;i:=0;
    while not eof(gutf) do
    begin
     try
     got:=0;
     i:=i+1;
     //if i>1000000 then break;
     //got:=got+1;
     readln(gutf,s);
     if length(s)<2 then begin got:=got+1;continue; end;//penaltia välilyönneistä
     if length(s)>15 then continue;
     try
     wnum:=gutlist.indexof(s);
     except continue;end;
     //if wnum<0 then continue;
     //writeln(pw^);
     //WRITE(' ',i);
     try
     ostr.writeWORD(WNUM);
     except write('!');continue;end;
     //ss.add(s);
     //write(wnum,' ');
     //if got>16 then begin  writeln(ss.commatext,got);got:=0;ss.clear; end;
     except writeln('ERROR ',s,ss.count);end;
    end;
    finally WRITELN('DONE');ostr.free;end;
end;
   procedure tsynonyms.gutcoocs;
var mysyn:array of word;
var gutf,outf:textfile;i,j,occurs:integer;
  line,pline,s1,s2,p1,p2,prevw:ansistring;
   //gutcc:array of byte;
   spos,sn1,sn2,ps1,ps2:integer;
   gutlist:tstringlist;
   onesyns:tlist;
   synws,maxoccurs,maxsyns:integer;
   maxsyn:ansistring;
   tokencount,typecount:longword;
   //ocs1,ocs2:array[0..5730] of word;
   ocs1,ocs2:array of word;
   bigvars,bigvals:array[0..15] of word;
   ppp,sss,vvv:pword;
   ocfile:file;
  procedure wdone;
  var jj:integer;
   begin


     //if ps1=21 then writeln('<li>DONE:',ps1) else exit;
     //if (s1='aallokko') then       writeln('<li>xx',line);
    //mysyn[2]:=666;
     sss:=pword(mysyn)+PS1*5730;
     big16(sss,ppp,vvv,ps1,gutlist);
     //if ps1=21 then
     //writeln('<li>',p1,':::::');
     //if vvv^>100  then
     //for jj:=0 to 15 do if (vvv+jj)^=0 then break else  writeln(gutlist[(ppp+jj)^],(vvv+jj)^);    //if ps1=21
      //writeln('</li>');
     if synws>maxsyns then
     begin
     maxsyns:=synws;
     end;
     synws:=0;maxoccurs:=0; maxsyn:='eiei';
     occurs:=0;
     //if sn1>300 then exit;
     //if synws>1000 then writeln('<li>',p1, '/s:',synws,' /o:',maxoccurs,' /m:',maxsyn);
   end;

begin
  maxoccurs:=0;maxsyns:=0;synws:=0;
  onesyns:=tlist.create;
  setlength(mysyn,5730*5730*2);
  ppp:=@bigvars;
  vvv:=@bigvals;

  setlength(ocs1,5730);
  setlength(ocs2,5730);
   gutlist:=tstringlist.create;
   gutlist.sorted:=true;
   gutlist.loadfromfile('gutsanat.ansi');
   //writeln(gutlist.text,gutlist.count);exit;
   assign(gutf,'gut.fi');
   reset(gutf);
   assignfile(ocfile,'gut.ocs');
   rewrite(ocfile,1);
   //blockread(ocfile,ocs1[0],5730*2);
   //for i:=0 to 5729 do writeln('<li>',gutlist[i],ocs1[i]); exit;
    assign(outf,'gut_conc_nums.lst');
    rewrite(outf);
    i:=0;occurs:=0;
    //fillchar(gutcc,sizeof(gutcc),0);
    fillchar(ocs1[0],length(ocs1)*2,0);
    fillchar(ocs2[0],length(ocs2)*2,0);
    //if 1=0 then
    ps1:=0;ps2:=0;
    while not eof(gutf) do
    begin
      i:=i+1;
      //if i>6000000 then break;
     readln(gutf,line);
     //writeln('<li>',line,' :',sn1);
     spos:=pos(' ',line);
     s2:=copy(line,spos+1);
     s1:=copy(line,1,spos-1);
     //if s1='ahdinko' then writeln('!!!',s2,occurs,line);
     if pline<>line then
     begin
         try
         typecount:=typecount+1;
         try
         sn1:=gutlist.indexof(s1);//sn1:=integer(pointer(gutlist.objects[sn1]));
         sn2:=gutlist.indexof(s2);//sn2:=integer(pointer(gutlist.objects[sn2]));
         except writeln('!');end;
         //if sn1=21 then writeln('<li>Z:',sn2,s2,occurs);
         //writeln(i,p1,ps1,':',p2,ps2,occurs);
         //if ps1=21 then writeln('<li>',p2,occurs,'::::',sn1,s1,sn2,s2);
         try
         if (ps1<0) OR  (ps2<0) or (ps1>5730) OR  (ps2>5730) then  begin occurs:=1;end
         else
         begin      //both are in sanalist
            try
            ocs1[ps1]:=ocs1[ps1]+1;
            ocs2[ps2]:=ocs2[ps2]+1;
            except writeln('(',ps1,',',ps2,')');end;
            writeln(outf,ps1,',',ps2,',',occurs);

               //writeln(occurs,'/',maxoccurs,' ',synws,'/',maxsyns);
               {if occurs>maxoccurs then
               begin
                maxoccurs:=occurs;
                maxsyn:=p2;//writeln('!',ps2,maxoccurs,'+',maxsyn);
               end;}
//               mysyn[ps1*5730+ps2]:=mysyn[ps1*5730+ps2]+occurs+1;
               //if ps1=21 then writeln('(',ps2,'/',mysyn[ps1*5730+ps2],'/',occurs,')');
 //              if (ps1<>sn1) then wdone;
              //synws:=synws+1;
              //i:=i+1;//if i mod 4000=1 then writeln(i div 1000);
              occurs:=0;
           end;
           except writeln('\');end;

         //if sn1>2500 then exit;
       except writeln('??',sn1,'/',sn2);end;
     end else begin tokencount:=tokencount+1;occurs:=occurs+1;end;//if sn1=21 then writeln('***',occurs,line);
     //occurs:=occurs+1;
     pline:=line;
       p2:=s2;p1:=s1;
         ps1:=sn1;ps2:=sn2;
    //writeln(outf,s1,sn1,' ',s2,sn2,' ',occurs);
     //gutcc(
     //if ch in [^m,^j] then
 end;
    writeln('<h1>',maxsyns,'</h1>');
    for i:=0 to 5729 do  ocs1[i]:=(ocs1[i]+ocs2[i]);
    blockwrite(ocfile,ocs1[0],5730*2);
       closefile(ocfile);
       close(outf);
   //  writeln('<li>',i,gutlist[i],':',ocs1[i],' / ',ocs2[i]);
end;

type string16=string[15];

procedure tsynonyms.gutmatrix;
var instr:tfilestream;binf:file;i:word;matr:array of longword;    prevs:array[0..31] of word;
    we:longint;
begin
   fillchar(prevs,sizeof(prevs),0);
   //gutlist:=tstringlist.create;
   //gutlist.loadfromfile('gutsanat.ansi');
   setlength(matr,5730*5730);
   instr:=tfilestream.create('gutnums.bin',fmopenread);
   AssignFile(binf, 'guts.mat');
   fillchar(prevs,sizeof(prevs),0);

   while instr.Position<instr.Size do
    begin
     move(prevs[0],prevs[1],31*2);
     prevs[0]:=instr.readword;
      //if prevs[0]=3 then write(^j,gutlist[prevs[16]],gutlist[prevs[0]],': ');
      if prevs[16]=0 then continue;
      if prevs[0]=0 then continue;
      we:=0;
      //for i:=99990 to 16 do if i<>8 then //we:=we+(16 div (abs(i-16)));
      //  IF I<>8999 THEN matr[prevs[8]*5730+prevs[i]]:=matr[prevs[8]*5730+prevs[i]]
      //   +1+(8 - (abs(i-8))) DIV 3;
         //+(16-abs(i-16) div 8)+1;//lisäpojot lähimmille
     //for i:=0 to 31 do    matr[prevs[16]*5730+prevs[i]]:=matr[prevs[16]*5730+prevs[i]]+4;
     for i:=0 to 31 do    matr[prevs[16]*5730+prevs[i]]:=matr[prevs[16]*5730+prevs[i]]+1;//lisäpojot lähimmille
     for i:=8 to 24 do    matr[prevs[16]*5730+prevs[i]]:=matr[prevs[16]*5730+prevs[i]]+1;//lisäpojot lähimmille
     for i:=12 to 20 do    matr[prevs[16]*5730+prevs[i]]:=matr[prevs[16]*5730+prevs[i]]+1;//lisäpojot lähimmille
     for i:=14 to 18 do    matr[prevs[16]*5730+prevs[i]]:=matr[prevs[16]*5730+prevs[i]]+1;//lisäpojot lähimmille
     //for i:=15 to 17 do  IF I<>16 THEN  matr[prevs[16]*5730+prevs[i]]:=matr[prevs[16]*5730+prevs[i]]+2;//lisäpojot lähimmille
     //for i:=8 to 24 do write(' ',gutlist[prevs[i]],matr[prevs[16]*5730+prevs[i]]);}
    end;
    writeln('donereadmatrix');
    try
         Rewrite(binf, length(matr)*4);
         Blockwrite(binf, matr[0], 1);
       finally
         writeln('writtem');
         CloseFile(binf);end;
end;

   procedure getbigs(var tosort:pword;bigs,bigvals:pword;w:word;sl:tstringlist);
   var i,j,posi,fils:word;d:boolean;
   begin
     //exit;
     //d:=false;//w=21;
    //if d then writeln('+++',word((tosort)^),sl[w],'<hr>');
    fillchar(bigs^,32*2,0);
    fillchar(bigvals^,32*2,0);
    //if d then for i:=0 to 50 do if (tosort+i)^>0 then writeln(i,sl[i],' <b>',i,'=',(tosort+i)^,'</b>');// else writeln(sl[i]);

    for i:=0 to 5730 do
    begin
      posi:=31;//fils:=0;
      if (tosort+i)^>0 then //(bigvals+10)^ then
      begin
      //writeln('<li>',i,sl[i],' <b>',i,'=',(tosort+i)^,'</b>');
      for j:=0 to 31 do
       begin
        //if d then writeln(' /',j,'.',(bigvals+j)^,'/ ');//,(tosort+i)^>(bigvals+j)^);
        if (tosort+i)^>(bigvals+j)^ then begin //if d then writeln(j,'.',(bigs+j)^);
          posi:=j;break;end;
       end;
      end;
      if posi<31 then
      begin
       fils:=fils+1;
       move((bigs+posi)^,(bigs+posi+1)^,(31-posi));
       move((bigvals+posi)^,(bigvals+posi+1)^,(31-posi));
       move(i,(bigs+posi)^,2);
       move((tosort+i)^,(bigvals+posi)^,2);
      end;
    end;
end;

procedure tsynonyms.gutscarse;
var //instr:tfilestream;
    prevs:array[0..31] of word;
   i,j,k,m:word;
   w,ocs,rowoc:longword;
   rel:longword;
   matr:array of longword;
   relmatr:array of word;
   gutlist:tstringlist;
   ppp,  sss,vvv:pword;
   bigvars,bigvals:array[0..31] of word;
   scarmat:array of word;
   scarf,binf:file;
   begin
     fillchar(prevs,sizeof(prevs),0);
    gutlist:=tstringlist.create;
    gutlist.loadfromfile('gutsanat.ansi');
    setlength(matr,5730*5730);
    setlength(scarmat,5730*32);
    setlength(relmatr,5730*5730);
     ppp:=@bigvars;
     vvv:=@bigvals;
     try
       AssignFile(binf, 'guts.mat');
          Reset(binf, length(matr)*4);
          Blockread(binf, matr[0], 1);
        finally
          writeln('countsread');
          CloseFile(binf);end;

     writeln('donereadmatrix');
     //readln;
    for i:=0 to 5728 do
    begin
     rowoc:=matr[i*5730+i];
     //write('',^j,^j,gutlist[i],rowoc,':');
     for j:=0 to 5728 do
     begin
       ocs:=matr[i*5730+j];
       //rel:=matr[j*5730+j];
       //if ocs<3 then continue;
       rel:=((ocs)*10000) div round(sqrt(rowoc*matr[j*5730+j]+1));
       //rel:=200000*ocs div (rowoc*matr[j*5730+j]+1);

       //if rel>150 then write(ocs,gutlist[j],rel,' ');
       try
       relmatr[i*5730+j]:=rel;
       //if rel>500 then write(gutlist[j],ocs,'/',rel,' ');

      except   write(i*5730+j,'!!!!!!!! ',rel,' ');end;
     end;

     //               mysyn[ps1*5730+ps2]:=mysyn[ps1*5730+ps2]+occurs+1;

    // procedure big16(var tosort,bigs:pword;bigvals:pword;w:word;sl:tstringlist);

    end;
    for i:=0 to 5730 do
    begin
      sss:=pword(relmatr)+i*5730;
      write(^j,^j,gutlist[i],sss^,':');
      getbigs(sss,ppp,vvv,i,gutlist);
      TRY
      for j:=0 to 31 do if bigvars[j]>0 then IF BIGVARS[J]< 5730 THEN write(' ',gutlist[bigvars[j]],bigvals[j]);
     except writeln('failbigs',BIGVARS[J]);end;

    end;
         try
       AssignFile(binf, 'guts.mat');
          Reset(binf, length(matr)*4);
          Blockread(binf, matr[0], 1);
        finally
          writeln('countsread');
          CloseFile(binf);end;



  end;
 { procedure splitl(line:string16;var snum,len:longint);
  var i:word;pastsp:boolean;s1,s2:string16;
  begin
   s1:='';s2:='';
    pastsp:=faLSE;
     for i:=1 to length(line) do
        if LINE[I]='/' Then pastsp:=true else
        if pastsp then s2:=s2+line[i] else s1:=s1+line[i];
     snum:=strtointdef(s1,0);
     len:=strtointdef(s2,0);
     //wri
  end;
var linefile,outfile:textfile;line,pline:string;
    spos:word;s1,s2,p1,p2:ansistring;
    typecount:longint;sn1,sn2,pn1,pn2:word;i,j:integer;
    gutlist,linesplit:tstringlist; //will use gutenberg short wordlist for numering - requires later conversion into sanatall
    freqs:array of longint;
    binfile:file; snum,cou,tot:longint;rel:integer;
begin
  setlength(freqs,5730);
  gutlist:=tstringlist.create;
  gutlist.loadfromfile('gutsanat.ansi');
  linesplit:=tstringlist.create;
  assign(linefile,'gutlines.nums');
  reset(linefile);
  AssignFile(binfile, 'guts.ocs');
  try
        Reset(binfile, length(freqs)*4);
        Blockread(binfile, freqs[0], 1);
      finally
        writeln('countsread');
        CloseFile(binfile);end;
  //assignfile(outfile,'gutx2.sums');//numeroina, tuplana, vaatii sorttaamisen myöhemmin
  //rewrite(outfile);i:=0;
  linesplit.Delimiter:=' ';
  //linesplit.StrictDelimiter:=true;
  typecount:=0;pn1:=0;
  while not eof(linefile) do
  begin
    i:=i+1;
    if i>600 then break;
    readln(linefile,line);
    try
    //typecount:=typecount+1;
    linesplit.commatext:=line;
    splitl(linesplit[0],snum,tot);
    writeln('<li><b>',gutlist[snum],' ',tot,'</b> ',freqs[snum],': ');//,linesplit[0],'#',linesplit.count,':',linesplit.count,':');//,linesplit[0],linesplit[1],linesplit[2]);
    for j:=1 to linesplit.count-1 do
    begin
      splitl(linesplit[j],snum,cou);
      //if cou<3 then continue;
      rel:=cou*9000000 div(tot*freqs[snum]);
      if rel>20 then writeln('<b>',gutlist[snum],'</b>/',freqs[snum],' ',rel,'/',cou) else writeln(gutlist[snum],freqs[snum],':',rel,'/',cou);


    end;
    continue;
    if linesplit[1]<>p1 then
    begin
      p1:=linesplit[1];pn1:=strtointdef(p1,0);
      freqs[pn1]:=typecount;
      writeln(gutlist[pn1-1],' #');

    end;//sn1:=integer(pointer(gutlist.objects[sn1]));
    if linesplit[2]<>p2 then
    begin
      p2:=linesplit[2];pn2:=strtointdef(p1,0);
      freqs[pn1]:=typecount;
    //writeln(gutlist[pn1-1],typecount);typecount:=0;
   end;//sn1:=integer(pointer(gutlist.objects[sn1]));
   typecount:=typecount+strtointdef(linesplit[0],0);
   //writeln(outfile,pn1,' ',pn2, #10, pn2,' ',pn1);
   except writeln('!');//,i,s1,' ',s2);
   end;
   end;
    {AssignFile(binfile, 'guts.ocs');
      try
        ReWrite(binfile, sizeof(freqs)*4);
        BlockWrite(binfile, freqs[0], 1);
      finally
        writeln('binsaved');
        CloseFile(binfile);end;
        }
end;
}
procedure tsynonyms.countguts;
var parifile,outfile:textfile;line,pline:string;
    spos:word;s1,s2,p1,p2:ansistring;
    typecount:longint;sn1,sn2,pn1,pn2:word;
    i,j:integer;
    gutlist,linesplit,synlist:tstringlist; //will use gutenberg short wordlist for numering - requires later conversion into sanatall
    freqs:array of longint;
    binfile:file;
begin
  setlength(freqs,5730);
  writeln('binsave',length(freqs)*4);
  gutlist:=tstringlist.create;
  synlist:=tstringlist.create;
  gutlist.loadfromfile('gutsanat.ansi');
  linesplit:=tstringlist.create;
  assign(parifile,'gutx2.nums');
  reset(parifile);
  assign(outfile,'gutlines.nums');
  rewrite(outfile);
  //assignfile(outfile,'gutx2.sums');//numeroina, tuplana, vaatii sorttaamisen myöhemmin
  //rewrite(outfile);i:=0;
  linesplit.Delimiter:=' ';
  //linesplit.StrictDelimiter:=true;
  typecount:=0;pn1:=0;i:=0;
  synlist.clear;synlist.sorted:=true;
  while not eof(parifile) do
  begin
    i:=i+1;
    //if i>60000 then break;
    readln(parifile,line);
     try
     //typecount:=typecount+1;
     linesplit.commatext:=line;
     //writeln(linesplit.count);//,linesplit[0],linesplit[1],linesplit[2]);
     if linesplit[1]<>p1 then
     begin
      freqs[pn1]:=typecount;
      //p1:=gutlist[pn1-1];
      writeln(outfile,pn1,'/',typecount,',',copy(synlist.commatext,0,80));
      //writeln('<li>',p1,gutlist[pn1],typecount,':');
      //writeln('.',pn1);
      //for j:=999 to min(200,synlist.count-1) do
      //  if integer(pointer(synlist.objects[j]))>5 then
      //    writeln(gutlist[integer(pointer(synlist.objects[j]))],'(',synlist[j],')');
      typecount:=0;
      synlist.clear;
      p1:=linesplit[1];pn1:=strtointdef(p1,0);
     end;//sn1:=integer(pointer(gutlist.objects[sn1]));
     //if linesplit[2]<>p2 then //always is
     begin
      try    //writeln(synlist.count);
      if strtointdef(linesplit[0],0)>1 then
      //synlist.addobject(linesplit[0], tobject(pointer(strtointdef(linesplit[2],0))));
      synlist.add(linesplit[2]+'/'+linesplit[0]);
      //synlist.addobject(linesplit[2]+'/'+linesplit[0], tobject(pointer(strtointdef(linesplit[0],0))));
      except writeln('no');end;
      p2:=linesplit[2];pn2:=strtointdef(p2,0);
     end;//sn1:=integer(pointer(gutlist.objects[sn1]));
     typecount:=typecount+strtointdef(linesplit[0],0);
     //writeln(outfile,pn1,' ',pn2, #10, pn2,' ',pn1);
     except writeln('!',line);//,i,s1,' ',s2);
     end;
   end;    exit;
    AssignFile(binfile, 'guts.ocs');
      try
        ReWrite(binfile, length(freqs)*4);
        BlockWrite(binfile, freqs[0], 1);
      finally
        writeln('binsaved',sizeof(freqs)*4);
        CloseFile(binfile);end;

     close(outfile);
end;
procedure tsynonyms.readgutansi;
var parifile,outfile:textfile;line,pline:string;
    spos:word;s1,s2,p1,p2:ansistring;
    sn1,sn2,pn1,pn2:integer;i,hits:longint;
    gutlist:tstringlist; //will use gutenberg short wordlist for numering - requires later conversion into sanatall
begin
 //writeln('disabled tmp');exit;
  assign(parifile,'gut.fi');
  reset(parifile);
  assignfile(outfile,'gutx2.fi');//numeroina, tuplana, vaatii sorttaamisen myöhemmin
  rewrite(outfile);
  pn1:=0;pn2:=0;
  gutlist:=tstringlist.create;
  gutlist.loadfromfile('gutsanat.ansi');
  hits:=0;
  //writeln(gutlist.indexof('aikuinen'),'"""');exit;
  while not eof(parifile) do
  begin
    i:=i+1;
    //if i>60000 then break;
    readln(parifile,line);
    if i mod 10000=0 then writeln(line);
    spos:=pos(' ',line);
    s2:=copy(line,spos+1);
    s1:=copy(line,1,spos-1);
    //if s1='aikuinen' then writeln('<li>',hits,'.',i,'>',line,'//',pn1,'.',pn2,p2);
     try
     //typecount:=typecount+1;
     if s1<>p1 then begin p1:=s1; pn1:=gutlist.indexof(s1);end;//sn1:=integer(pointer(gutlist.objects[sn1]));
     if s2<>p2 then begin p2:=s2; pn2:=gutlist.indexof(s2);end;//sn1:=integer(pointer(gutlist.objects[sn1]));
     if (pn1<0) or (pn2<0) then continue;
     hits:=hits+2;
     writeln(outfile,pn1,' ',pn2, #10, pn2,' ',pn1);
     if pn1=47 then writeln('<li>',hits,'>>>>',line,'//',pn1,'.',pn2);
     //if s1='aikuinen' then writeln('<li>',line,'//',s1,s2);
     except writeln('!');//,i,s1,' ',s2);
     end;
     //pline:=line;
     //p2:=s2;p1:=s1;
     //pn1:=sn1;pn2:=sn2;

 end;
  close(parifile);
  close(outfile);
end;

procedure tmp_getnum;  //listaa testiksi
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
          else writeln(copy(slist[synarray[i,j]
          ],length(slist[synarray[i,j]])-10));
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
  //assign(ifile,'sanatvaan.ansi');  //synonyymit/liittyvät sanat
  //reset(ifile);
  assign(resfile,'sanatnum.ansi');  //synonyymit/liittyvät sanat
  rewrite(resfile);
  assign(synfile,'syn_ok.ansi');  //synonyymit/liittyvät sanat
  reset(synfile);
  fillchar(synarray, sizeof(synarray),0);
 i:=0;
  {while not eof(ifile) do
  begin
   i:=i+1;
   //writeln(i);
   readln(ifile,rivi);
   linelist.delimitedtext:=rivi;
   //for j:=0 to linelist.count-1 do writeln(j,'/',linelist[j]);
   reslist.add(trim(linelist[1]));
  end;}
  reslist.loadfromfile('sanatvaan.ansi');
  //writeln('<li>',reslist.indexof('haarukka'),reslist.Text);exit;
  i:=0;
  //close(ifile);
  linelist.Delimiter:=',';
  //linelist.sorted:=true;
  linelist.duplicates:=dupIgnore;
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
   //if linelist.count>31 then
   hits:=0;
   psan:=reslist.indexof(linelist[0]);
   //linelist.Delete(0);
   //linelist.sort;
   //try   writeln('<li><b>',psan,reslist[psan],'</b> ',linelist.commatext,' ///',rivi);   except writeln('</b>--',linelist.Text);end;   continue;
   if psan>=0 then  //pitäis saada talteen myös tieto synonyymien keskinäisistä yhteyksistä
   begin
    writeln(resfile);
   for j:=0 to linelist.count-2 do
   begin
        sana:=linelist[j];
        if linelist.indexof(sana)<j then continue;//begin writeln('<li>dup:',linelist[j],' in ',linelist[0]);continue;end;
        posi:=reslist.indexof(sana);
        if posi>0 then //writeln('/',sana,posi)
        begin
          synarray[psan,hits]:=posi;
          write(resfile,sana,',',posi);
          hits:=hits+1;
        end;
   end
   end else    //eka sana (jonka synonyymejä rivillä listataan) ei esiinny sanalistassa
   begin
     writeln('<li>?',linelist[0],':');
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

procedure tsynonyms.makelist;  //read synlist with 1 wrd/line, \n separating synsets
  var     binf:file;

var
  //linehits: TList;inf,synf,misfile,sanaf,
    synsetfile,resfile:textfile;
    restxt,resnums,sana,ekasana:ansistring;
    snum,enum:integer;
    cc:integer;i:integer;
    test:array of word;
begin
try
  setlength(syns,synsans*syncols);
  //setlength(syns,10000000);
  writeln('size',length(syns));
  assign(resfile,'synlist.ansi');  //kaikki ei-yhdyssanat
  rewrite(resfile);
  cc:=0;
  writeln(resfile,'alkaa');
  writeln('alkaa');
  //closefile(resfile);exit;
  //savebin;exit;
  slist:=tstringlist.create;
  slist.loadfromfile('sanatvaan.ansi');
  assign(synsetfile,'syn_allx.ansi');  //kaikki ei-yhdyssanat
  reset(synsetfile);
  //if 1=0 then
  enum:=0;
  while not eof(synsetfile) do
  begin
    cc:=cc+1;
    readln(synsetfile,sana);
    //writeln(resfile,sana,cc);
    //if cc>=373831 then break;
    //if cc>333 then break;
    //  writeln(resfile,cc,sana,sana='');
    //continue;
    //writeln(resfile,snum,sana,enum);
    //continue;
    if (sana='') or (eof(synsetfile)) then
    begin
      //if enum<0 then continue;
      //writeln(resfile,ekasana,',',restxt);//,restxt='',enum,'!');
      restxt:='';
      if eof(synsetfile) then break;
      readln(synsetfile,ekasana);
      enum:=slist.indexof(ekasana);
      continue;
    end;
    sana:=stringreplace(trim(sana),'_','',[rfReplaceAll]);
    sana:=stringreplace((sana),'-','',[rfReplaceAll]);
    snum:=slist.indexof(sana);
    if (snum>=0) and (enum>=0) then
    begin
      setsyn(enum,snum);
      writeln(resfile,enum,sana,snum);
    end;
    restxt:=restxt+sana+', ';

  end;
  writeln('<li>CLOSE*');

  finally
        savebin(synsans,syncols,syns,'syn.bin');
        close(resfile);
        writeln('resclosed');
        close(synsetfile);
        writeln('synsetclosed');
  end;
end;
  {
 linehits:=tlist.create;
//inf:=tfilestream.create('wikithe.txt',fmopenread);  //synonyymit/liittyvät sanat
//assign(inf,'gutsanat.iso');  //synonyymit/liittyvät sanat
//assign(inf,'sense.nums');  //synonyymit/liittyvät sanat
//assign(inf,'wikithe.ansi');  //synonyymit/liittyvät sanat
assign(inf,'syn_allx.ansi');  //synonyymit/liittyvät sanat
//assign(inf,'sanatall.arev');  //kaikki ei-yhdyssanat
reset(inf);
assign(synf,'syn_ok.ansi');  //synonyymit/liittyvät sanat
rewrite(synf);
assign(sanaf,'sanat_ok.ansi');  //synonyymit/liittyvät sanat
rewrite(sanaf);
assign(misfile,'testimiss.the');  //synonyymit/liittyvät sanat
assign(numfile,'syn_ok.num');  //synonyymit/liittyvät sanat
rewrite(misfile);
rewrite(numfile);

fillchar(sanataulu,sizeof(sanataulu),0);
 cc:=0;
 hitcount:=0;eitaivu.hitcount:=0;
 writeln('<li>xxx');
 //hitfs:=tfilestream.create('wikithe.txt',fmcreate);  //numerolista
 //misfs:=tfilestream.create('wikithe.txt',fmcreate);  //tunnistamattomat pohditaviksi
 try


   while //(cc<1000000) and
  (not eof(inf))  do
   begin
    try
    cc:=cc+1;
     if cc>212388 then break;
     //if cc>10000 then break;
    readln(inf,sana);
    if sana='' then
    begin
        //writeln('<hr>');
        if olisana and (ghits>1)then
        begin
         //writeln(' //',prevsana,integer(linehits[0]));
         sanataulu[integer(linehits[0])]:=copy(prevsana,1,20);
          writeln(synf,hitline);
          for j:=0 to linehits.count-1 do write(numfile,inttostr(integer(linehits[j]))+',');
          if (linehits.Count>0) then  writeln(numfile,'') else writeln(numfile);
          end;// else  writeln(reversestring(sana));
          ghits:=0;hitline:='';
        linehits.clear; olisana:=false;ekasana:=true;continue;
    end;
    //if sana<>'tytär' then continue;
    sana:=stringreplace(trim(sana),'_','',[rfReplaceAll]);
    sana:=stringreplace((sana),'-','',[rfReplaceAll]);

    if ekasana then prevsana:=sana;
    sana:=reversestring(sana);
    akon:='';
    //if sana='' then begin writeln(outf,'*****');continue;end else
    voksointu(sana,hakueietu,hakueitaka);
    if hakueitaka and hakueietu then   continue;   //autoritääristen harmiksi
    hakurunko:=taka((sana));
    hakukoko:=sana;
    hits:=0;
    hitnum:=etsiyks(hakurunko,akon,hakukoko,hakueietu,hakueitaka,nominit.sijat[0],nil,nil,hits);
    if hakurunko[1]='a' then
    //res:=res+
    if hitnum=0 then hitnum:= etsiyks(hakurunko,akon,hakukoko,hakueietu,hakueitaka,
    verbit.sijat[0],nil,nil,hits); //verb permuo päättyy "a"
    if hitnum=0 then begin hitnum:=eitaivu.sexact(sana,eitaivu.sanalista);if hitnum<>0 then hitnum:=26000+hitnum;end;
    //if hits>0 then writeln('!!!',hitlist[hitcount],sans[hitlist[hitcount]].san,sans[hitlist[hitcount]].akon);//<li>H: ',sans[hitlist[hitcount]].san,sans[hitlist[hitcount]].akon,'#',hitlist[hitcount]);
    if hits=0 then if hitnum>0 then hits:=hits+1;// else writeln('<li>;:',reversestring(sana),'</li>');
    if ekasana then if hits>0 then olisana:=true;
    //if ekasana then writeln('<li>',reversestring(sana),hitnum);
    ekasana:=false;
    //if hits>1 then writeln(outf,akon,sana,'=',trim(res),' ',cc,'!',hits);// else writeln(outf,'--',akon+sana);//'<b style="color:red">'+akon+sana+'</b> ');
    //if hitnum>>0 then writeln(misfile,hitnum,',',string(sana));
    //writeln('<li>',reversestring(sana),'/ekako:',eka,' /sanako:',olisana,hitnum,' ',hits);
    //if hits=0 then writeln(misfile,sana)   else //
    if hits>0 then
     begin
       //hitline:=hitline+^j+reversestring(sana);ghits:=ghits+1;
       hitline:=hitline+reversestring(sana)+',';ghits:=ghits+1;
       linehits.add(pointer(hitnum));
       //writeln('<li style="color:green">',reversestring(sana),'</li>')
       //if (hits mod 10<>0) then
       //writeln('+');//<li>',akon,sana,'=',trim(res),' ',cc,'!',hits);
//        writeln(outf,akon,sana,'=',trim(res),' ',cc,'!',hits);
         // else writeln(outf,'--',akon+sana);//'<b style="color:red">'+akon+sana+'</b> ');
         ;//else  writeln('<li><b>y:',akon,sana,'=',trim(res),' ',cc,'</b>',hits);// else writeln(outf,'--',akon+sana);//'<b style="color:red">'+akon+sana+'</b> ');
      end;
    except   writeln('<li>EiEtsi',sana,sana='','!');end;
    //if cc>20000 then break;
    //writeln('<li>',sana,res,hits);
  end;
   writeln('<li>didit');
 finally
   close(inf);
   close(synf);
   close(misfile);
   close(numfile);
 //hitfs.free;misfs.free;
 end;
 for cc:=0 to 30000 do  writeln(sanaf,resus[cc]);
 closefile(sanaf);
 end;
 }
end.

