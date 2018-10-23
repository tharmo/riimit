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
procedure gutsparse;
procedure gutextract;
procedure gutmatrix;
procedure gutkerro;
function haesyno(sanum:word;var res:tlist;sl:tstringlist):integer;
function haesynolist(var sanums:tlist;sl:tstringlist):word;
end;
procedure ngrams;
procedure ngramlemmas(fil:string);
procedure grammat(fil:string);


procedure tmp_getnum;
procedure tmp_num;

implementation
 uses math,riimiutils;
type tgutcc=array of word;
  tagut=array[0..15] of word;
type  tgutw=array of word;

procedure ngrams;
var slist,ihte:tstringlist;
    ngf:textfile; ch:ansichar; ind:word;
    line:array[0..2] of ansistring;ok:boolean;
    pp,ss:longword;
begin
slist:=tstringlist.create;
ihte:=tstringlist.create;
ihte.sorted:=true;
slist.loadfromfile('sanatvaan.ansi');
//ihte.loadfromfile('klklemmas.lst');
  assign(ngf,'klk_siivo1.srt.iso');
  reset(ngf);
  ind:=0;
  //writeln(ihte.commatext);
  while not eof(ngf) do
  begin
      read(ngf,ch);
    if pos(ch,' '+^j)>0 then
    begin
    if (ch=^j) then
    begin
     ind:=0;
     //if not ok then write('.');
     //if ihte.indexof(line[0])>=0 then writeln(line[0],' ',line[2])
     ;//else writeln(line[0]);

     //if line[1][1]=ansilowercase(line[1][1]) // then writeln('!!!');
     if ok then if length(line[0])<16 then if length(line[1])<16 then
     writeln(line[0],' ',line[1],' ',line[2]);
     line[0]:='';line[1]:='';line[2]:='';ok:=true;
     end else
    if ind=0 then ind:=1 else ind:=2;
     continue;
    end else
     if ind=0 then line[0]:=line[0]+ansilowercase(ch) else  //sana 1 voi olla isolla lauseen alusta
     line[ind]:=line[ind]+ch;
     if ind<2 then if pos(ch,'qwertyuiop��lkjhgfdsazxcvbnm')<1 then ok:=false;
     //if ind<2 then if pos(ch,'qwertyuiop��lkjhgfdsazxcvbnm')<1then if ind=1 then write(ch);
  end;
     //slist.loadfromfile('gutsanat.ansi');

end;

procedure listgrams;
VAR I,J:WORD;    vars,vals:array of word;
    slist:tstringlist;

begin
slist:=tstringlist.create;
slist.loadfromfile('sanatvaan.ansi');
setlength(vars,30001*32);
setlength(vals,30001*32);
READbin(SLIST.COUNT,32,2,vals,'wvals.scar') ;
READbin(SLIST.COUNT,32,2,vars,'wvars.scar') ;
for i:=0 to 1000 do
 begin                        //  ,word((bigs+j)^),'=',word((bigvals+j)^),'</b>');
  try
  write('<li>',slist[i],':<ul>');
  for j:=0 to 31 do
   if (vals[i*31+j])<>0 then if vals[i*32+j]=0 then break else
     write('<li>',j,' ',slist[vars[i*32+j]],'\',vals[i*32+j],' ');
  writeln('</ul>');
  except writeln(^j'???');end;
 end;
END;

procedure grammat(fil:string);

   procedure big32(bigs,bigvals:pword;bwrd,wrd,freq:word;sl:tstringlist);
   var i,j,posi,fils:word;d:boolean;slots:word;
   begin
     //d:=false;//w=21;
    //if d then writeln('+++',word((tosort)^),sl[w],'<hr>');
    //fillchar(bigs^,16,0);
    //fillchar(bigvals^,16,0);
    //if d then for i:=0 to 50 do if (tosort+i)^>0 then writeln(i,sl[i],' <b>',i,'=',(tosort+i)^,'</b>');// else writeln(sl[i]);
      slots:=32;//fils:=0;
      posi:=32;
      try
      if freq>0 then //(bigvals+10)^ then
      begin
      //write(^j'>',wrd,sl[wrd]);//,' <b>',i,'=',(tosort+i)^,'</b>');
      for j:=0 to slots-1 do
       begin
        if freq>(bigvals+j)^ then
        begin //if d then writeln(j,'.',(bigs+j)^);
          posi:=j;break;end;
       end;
      end;
      //write(freq,'=',posi);
      if posi<32 then
      begin
       move((bigs+posi)^,(bigs+posi+1)^,(2*(slots-posi-1)));
       move((bigvals+posi)^,(bigvals+posi+1)^,2*(slots-1-posi));
       //move(i,(bigs+posi)^,2);
       (bigs+posi)^:=wrd;
       (bigvals+posi)^:=freq;
       //move((tosort+i)^,(bigvals+posi)^,2);
      end;
      except writeln('*******************nopiso');end;
   // if bwrd=227  then for j:=0 to 15 do    writeln(j,'==<b>',word((bigs+j)^),sl[(bigs+j)^],'=',word((bigvals+j)^),'</b>');
   // if bwrd=227  then writeln('@@',posi);
   end;

var slist:tstringlist;
   numfile,freqfile:textfile;
   freqs:array[0..30000] of longword;
   freqlist:tstringlist;
   i,j,part:integer;
   sana1,sana2,s1f,s2f:array of integer;
   //sss:array of tlist;
   s1,s2,p1,p2:word;
   mainfreq,s1s2,cc,s3,tot:longword;
   sline,xx:string;
   sparts:array[1..3] of string;
   subws:tstringlist;
   // bigvars,bigvals:array[0..31] of word;
    vars,vals:array of word;
    myval,numer,denom:Qword;
    curtarget:word;
begin
 LISTGRAMS;EXIT;
  freqlist:=tstringlist.create;
  slist:=tstringlist.create;
  subws:=tstringlist.create;
  freqlist.loadfromfile('counts.tmp');
  for i:=0 to freqlist.count-1 do  freqs[i]:=strtointdef(freqlist[i],0) DIV 10;
  slist.loadfromfile('sanatvaan.ansi');
  setlength(vars,30001*32);
  setlength(vals,30001*32);
  assign(numfile,fil);
  reset(numfile);
  cc:=0;
  tot:=0;
  curtarget:=30000;
  writeln('gogogo');
  while not eof(numfile) do
  begin
   part:=1;sparts[1]:='';sparts[2]:='';sparts[3]:='';
   readln(numfile,sline);
   if trim(sline)='' then continue;
   //writeln('***',sline,'///');
   for i:=1 to length(sline) do
     if sline[i]=' ' then part:=part+1 else
     sparts[part]:=sparts[part]+sline[i];
    if sparts[1]='' then continue;
    s1:=strtointdef(sparts[1],0);
    s2:=strtointdef(sparts[2],0);
    s3:=strtointdef(sparts[3],0) div 2;
    //if s3>65535 then s3:=65535;
     if s1<>p1 then
     begin
         curtarget:=s1;mainfreq:=freqs[s1];
     end;
     try
     //tot:=tot+s3;
     //try
     //numer:=ROUND(POWER(s3,1.7));
     numer:=1000*s3;
     //except NUMER:=1000000;  end;
     try
     denom:=max(1,(mainfreq) *  (freqs[s2]));
     except DENOM:=1000000;  end;
     TRY
     //myval:=(((100000000*s3) div (mainfreq*mainfreq+10) div (freqs[s2]*freqs[s2]+10)));
     myval:=round((numer/denom));
     except MYVAL:=10000;writeln('???val:',numer,'/',denom,'=',myval,'???');  end;
     //IF MYVAL>1000 THEN  writeln('val:',numer,'/',denom,'=           ',myval);
     //WRITE(' ',MYVAL);
     if myval>65535 then
     begin
     writeln('<li>',sline,':::', slist[s1],slist[s2],' ', s3, ' // ',myval);
     myval:=65535;
     end;
     if myval>0 then
     big32(@vars[curtarget*32],
           @vals[curtarget*32],
           s1,s2,word(myval),slist);
     //      write(' ',s1,'.',s2,',',s3);
     //if s3>10 then subws.addobject(xx,tobject(pointer(s3)));
     except writeln(^j'NOBIGS!!!!!!',curtarget,'/',s1,'/',s2,'/',s3,' ',myval);end;
   p1:=s1;
   //if s1>1000 then break;
  end;
  //for i:=0 to slist.count-1 do
  savebin(SLIST.COUNT,32,2,vals,'wvals.scar') ;
  savebin(SLIST.COUNT,32,2,vars,'wvars.scar') ;

end;

procedure ngramlemmas(fil:string);
var ihte,slist:tstringlist;
    ngf:textfile; ch:ansichar;
    part,i,j:integer;inwrd:boolean;
    line:array[0..20] of ansistring;skip:boolean;//hits:tstringlist;
    hits:array[0..20] of ansistring;hitfreqs:array[0..20] of longword;hitnums:array[0..20] of word;hitkots:array[0..20] of word;
    hitcount:word;
    xlens:array[0..20] of word;
    wnum:integer;
    sana:ansistring;
    posi,runsaus,runsain,hitkot:integer;
    pp,ss:longword;
    freqs:boolean;
    myfreq:longint;
    freqar:array of longint;
    procedure addfreqs;
    var i,wf:integer;
    begin
       for i:=0 to hitcount-1 do
       begin
          wf:=hitnums[i];//integer(pointer(hits.objects[i]));
          try
          freqar[wf]:=freqar[wf]+myfreq; //hits[i]+1;
          //write(hits[i],freqar[wn],' ');
          except writeln('nono',wf,'/',myfreq);end;
       end;
     end;
    procedure haerunsain;
    var i:integer;
    begin
      try
      runsain:=hitnums[0];
      runsaus:=freqar[hitnums[0]];//integer(pointer(hits.objects[0]));
      if hitcount>1 then
      begin
       //for i:=0 to hitcount-1 do write('+',hitnums[i]);
       //for i:=0 to hits.count-1 do write(i,hits[i],integer(pointer(hits.objects[i])),'>');
        //for i:=1 to hits.count-1 do if length(pisin)<length(hits[i]) then pisin:=hits[i];
        for i:=1 to hitcount-1 do
          if runsaus<freqar[hitnums[i]] then //integer(pointer(hits.objects[i])) then
           begin
             runsain:=hitnums[i];runsaus:=freqar[hitnums[i]];//integer(pointer(hits.objects[i]));
           end;
       end;
       //if hitcount>1 then write('/',runsain);
      except writeln('***********',runsain);end;
    end;
   function oldhit(w:string):boolean;
   var j:integer;
   begin
     result:=true;
     for j:=0 to hitcount-1 do if hits[j]=w then exit;
     result:=false;
   end;
   var ffile:file;freqfile:textfile;  freqst:string;exitus:boolean;
begin
writeln(fil+'.iso');
ihte:=tstringlist.create;
slist:=tstringlist.create;
slist.loadfromfile('sanatvaan.ansi');
//hits:=tstringlist.create;
for i:=0 to slist.count-1 do
slist.objects[i]:=tobject(pointer(i));
//writeln(slist[0],integer(pointer(slist.objects[0])));
slist.sort;
slist.sorted:=true;
//exitus:=false;
//reset(ngf);
part:=0;
{while not eof(freqf) do  //add words and their freqs from vocabulary
begin
  readln(freqf,sana);
   posi:=pos(' ',sana);
   slist.addobject(copy(sana,1,posi-1),tobject(pointer(integer(strtointdef(copy(sana,posi+1),0)))));
   //writeln('<li>[',copy(sana,1,posi-1),'/',copy(sana,posi+1),'@',posi,'!',sana,']');
end;
//exit;}
//writeln(slist[21],integer(pointer(slist.objects[21])));exit;
freqs:=fileexists(fil+'.bin');
setlength(freqar,slist.count);
//writeln('freqs,',freqs);
  if  freqs then
  begin
    TRY
    assign(ffile,fil+'.bin');
    reset(ffile,slist.count*4);
    except writeln('failfile ', fileexists(fil+'.bin'),slist.count*4);end;
    blockread(ffile,freqar[0],1);
    closefile(ffile);
    //for i:=0 to slist.count-1 do slist.objects[i]:=TOBJECT(pointeR(freqar[i]));
    //for i:=0 to slist.count-1 do if freqar[i]>500 then writeln(slist[i],freqar[i],' ');
  end;
  try
  assign(ngf,fil+'.iso');
  reset(ngf);
  except writeln('not found fil ',fil);raise;end;
  assign(freqfile,fil+'.num');
  //writeln('xxx'+fil+'.iso');
  //assign(freqf,'klklemma.freqs');
  reset(freqfile);
  //writeln('freread');
  //reset(freqfile);
  part:=0;   //readln(ngf,freqst); readln(ngf,freqst);//writeln(';',freqst);; //readln(freqfile,freqst);
  while not eof(ngf) do
  begin
   read(ngf,ch);
      if (ch=^j) then
      begin
         try
           readln(freqfile,freqst);
           try
           //for i:=0 to part-1 do write(line[i],'/');
           myfreq:=strtointdef(freqst,0);
           //fillchar(hits,sizeof(hits),0);//hits.clear;
           //fillchar(hitfreqs,sizeof(hitfreqs),0);//hit-words not cleared .. nothing really need to be
           //writeln(line[0]);
           hitcount:=0;
           if (part<1) or (line[1][1]='*') then continue;
           for i:=part downto 2 do for j:=i-1 downto 1 do if line[i]=line[j] then line[i]:='';
           // begin //write('-',i,line[i],j,line[j]);line[i]:='';end;
           for i:=1 to part do
           try
             //if hits.indexof(line[i])<0 then //similar lemmas skipped
              //if not oldhit(line[i]) then //similar lemmas skipped
            if line[i]<>'' then
             begin
              //if line[i]=line[0] then ihte.add(line[0]);
              wnum:=slist.indexof(line[i]);
              if wnum>=0 then
              begin hitnums[hitcount]:=wnum;hitcount:=hitcount+1;
              end;
              //write(^j,line[0],hitcount);
              //IF FREQS THEN if wnum>=0 then
              //  begin hitnums[hitcount]:=wnum;hitcount:=hitcount+1;end;
              //  //hits.addobject(line[i],tobject(pointer(slist.objects[wnum])));//,tobject(pointer(wnum)));
              //IF NOT FREQS THEN if wnum>=0 then
              //  begin hitnums[hitcount]:=wnum;hitcount:=hitcount+1;end;//hits.addobject(line[i],tobject(pointer(slist.objects[wnum])));//,tobject(pointer(wnum)));
                //hits.addobject(line[i],tobject(pointer(wnum)));//,tobject(pointer(wnum)));
              //if freqs then if  wnum>=0 then writeln(',',wnum,'/',line[i]);
             end;
           except writeln('FAILfreqs:',line[0],runsain);;end;
           if hitcount>0 then
           begin
            if freqs then haerunsain else addfreqs;
               //if random(1000)=1 then
             //if hitcount>99990 then       //debuggin lim
             if freqs then if hitcount>0 then
             begin
              //write(^j,line[0],hitcount,'::');//,hits.commatext,slist.indexof(hits[1]),'/',slist.indexof(hits[2]),'/');
              //for i:=0 to hitcount-1 do try write(' >>',hitnums[i],slist[hitnums[i]],freqar[hitnums[i]]);except writeln('xx',runsaus,'/',runsain);end;
              //write('      =',slist[runsain],' ');
             end;
           end;// else writeln(line[0]);
           finally
            try //writeln(runsain,line[0],line[1],'//',slist[runsain]);
            if runsain>-1 then
             writeln(line[0], ' ',slist[runsain],' ',integer(pointer(slist.objects[runsain]))) else writeln(line[0],' ','*');
            //if line[0]='ahjoja' then exitus:=true;
           except writeln('FAIL:',line[0],runsain);;end;
           hitcount:=0;
           runsain:=-1;
           for j:=0 to 20 do begin line[j]:='';xlens[j]:=0;end;
           part:=0;
           skip:=false;
           end;
           except writeln('***');end;//writeln('fail - hit key');readln;end;

      end else
      begin
        if ch='$' then continue else
        if ch='/' then begin part:=part+1;skip:=false;end
        else
         if ch=' ' then skip:=true
        else if skip then  xlens[part]:=xlens[part]+1 else
          if ch='#' then begin  line[PART]:='';PART:=PART-1;skip:=true;end else
         if ch<>'^' then line[part]:=line[part]+ch;
       end;
         //if ind<2 then if pos(ch,'qwertyuiop��lkjhgfdsazxcvbnm')<1 then ok:=false;
         //if ok=false then if ind=1 then write(ch);
         //if exitus then exit;
   end;
     //slist.loadfromfile('gutsanat.ansi');
//   ihte.savetofile('klklemmas2.lst');
   //writeln('dadsdfasd');
   close(ngf);
   if not freqs then
   begin
     //writeln('gogogog');readln;
     assign(ffile,fil+'.bin');
     rewrite(ffile,length(freqar)*4);
     blockwrite(ffile,freqar[0],1);
     closefile(ffile);
     for i:=0 to slist.count-1 do if freqar[i]>=0 then writeln('<li>',slist[i],freqar[i]);
   end;
   exit;
   //assign(ngf,'klk.srt');
   //reset(ngf);
   //for ss:=ihte
end;

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
   //writeln('lis�� ', sy, 'sanan ', sa,' listaan (' ,length(syns));
   FOR hit:=0 TO SYNCOLS-1 DO
   IF asyn(sa,hit)<>0 then
   begin  //etsit��n eka vapaa paikka. Jos oli valmiiksi, keskeytet��n
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
   //writeln('lis�� ', sy, 'sanan ', sa,' listaan (' ,length(syns));
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
procedure tsynonyms.teegut; //lue .gutenbergin tuottama bin��ri
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
      AssignFile(gutbin, 'gutcc.bin');  //ei onnistu tstrinlistill� varmaan blockwrite
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

procedure tsynonyms.luegut; //lue .gutenbergin tuottama bin��ri
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
      AssignFile(gutbin, 'guttext.bin');  //ei onnistu tstrinlistill� varmaan blockwrite
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
        AssignFile(gutbin, 'guttext.bin');  //ei onnistu tstrinlistill� varmaan blockwrite
        writeln('ass');
        Rewrite(gutbin, length(gutarr));
        writeln('reset');
        Blockwrite(gutbin, gutarr[0], 1);
        writeln('wrote ',length(gutarr));
        closefile(gutbin);

        writeln('<li>luettu');


    except writeln('jotain m�tti',length(gutarr),'!!!');end;
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
  savebin(synsans,syncols,2,syns,'synmul2.bin');


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
    got:longword;
    ss,gutlist:tstringlist;
    wnum:word;
    ostr:tfilestream;
    pw:pword;
    sysmis:word;

begin
  sysmis:=5730;
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
     //got:=;
     //if i>1000000 then break;
     readln(gutf,s);
     try
     if s='' then begin ostr.writeword(sysmis);ostr.writeword(sysmis);continue;end;
     if length(s)<2 then begin wnum:=sysmis; end else//penaltia v�lily�nneist�
     if length(s)>15 then wnum:=sysmis else
     wnum:=gutlist.indexof(s);
     //if got<100 then begin got:=got+1;writeln('<li>',s,wnum,gutlist[wnum]);end;
     except wnum:=sysmis;end;

     //if wnum<0 then wnum:=5730;
     //writeln(pw^);
     //WRITE(' ',i);
     try
     ostr.writeWORD(WNUM);
     except write('!');continue;end;
     //ss.add(s);
     //write(wnum,' ');
     //if got>16 then begin  writeln(ss.commatext,got);got:=0;ss.clear; end;
     finally i:=i+1;end;
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
    we:longint; av:word;gutlist:tstringlist;
    sysmis:word;     cc:longword;
begin
  writeln('gutmatrix');
  sysmis:=5730;
   fillchar(prevs,sizeof(prevs),0);
   gutlist:=tstringlist.create;
   gutlist.loadfromfile('gutsanat.ansi');
   setlength(matr,5730*5730);
   instr:=tfilestream.create('gutnums.bin',fmopenread);
   AssignFile(binf, 'guts.mat');
   //fillchar(prevs,sizeof(prevs),sysmis);
   for i:=0 to 31 do prevs[i]:=sysmis;
  // writeln(

  cc:=0;
   while instr.Position<instr.Size do
    begin
     //writeln(instr.readword);continue;
     //if instr.Position>100000 then break;;
     av:=instr.readword;
     //if av=0 then continue;
    //matr[prevs[16]*5730+prevs[i]] write(^j^j,gutlist[av]);
    //if cc<100 then begin if av<>sysmis then writeln(av,gutlist[av]);cc:=cc+1;cc:=cc+1;end else exit;
     move(prevs[0],prevs[1],31*2);
     prevs[0]:=av;

     //write(' .',av);   continue;
     //if prevs[16]=9999 then prevs[i]:=0;//write('. ');
     //if prevs[0]=3 then write(^j,gutlist[prevs[16]],gutlist[prevs[0]],': ');
     // if prevs[0]=5730 then prevs[0]:=9999;
      //if prevs[0]=9999 then continue;
      //we:=0;
      //for i:=99990 to 16 do if i<>8 then //we:=we+(16 div (abs(i-16)));
      //  IF I<>8999 THEN matr[prevs[8]*5730+prevs[i]]:=matr[prevs[8]*5730+prevs[i]]
      //   +1+(8 - (abs(i-8))) DIV 3;
         //+(16-abs(i-16) div 8)+1;//lis�pojot l�himmille
     //for i:=0 to 31 do    matr[prevs[16]*5730+prevs[i]]:=matr[prevs[16]*5730+prevs[i]]+4;
     //for i:=0 to 31 do    matr[prevs[16]*5730+prevs[i]]:=matr[prevs[16]*5730+prevs[i]]+1;//lis�pojot l�himmille
     //for i:=8 to 24 do    matr[prevs[16]*5730+prevs[i]]:=matr[prevs[16]*5730+prevs[i]]+1;//lis�pojot l�himmille
//     for i:=12 to 20 do  if (av<5730)  then
    try
    if (prevs[16]<>sysmis)  then
    for i:=8 to 24 do
    begin
     if prevs[i]=sysmis then continue;
     if (i>12) and (i<20) then
     matr[prevs[16]*5730+prevs[i]]:=matr[prevs[16]*5730+prevs[i]]+2 //lis�pojot l�himmille
    else
     matr[prevs[16]*5730+prevs[i]]:=matr[prevs[16]*5730+prevs[i]]+1;//lis�pojot l�himmille
     //if matr[prevs[16]*5730+prevs[i]]>10 then  //    if prevs[i]<>0 then if prevs[16]<>0 then
     //write('  ',gutlist[prevs[16]],'/',gutlist[prevs[i]],matr[prevs[16]*5730+prevs[i]]);
    end;
    //try if prevs[16]=3 then writeln('*',gutlist[prevs[15]],'/',gutlist[prevs[17]]);    except write('!aaaa',i,':');end;
    except write('!',i,':');end;

     //for i:=14 to 18 do    matr[prevs[16]*5730+prevs[i]]:=matr[prevs[16]*5730+prevs[i]]+1;//lis�pojot l�himmille
     //for i:=15 to 17 do  IF I<>16 THEN  matr[prevs[16]*5730+prevs[i]]:=matr[prevs[16]*5730+prevs[i]]+2;//lis�pojot l�himmille
     //for i:=8 to 24 do write(' ',gutlist[prevs[i]],matr[prevs[16]*5730+prevs[i]]);}
    end;
           for i:=0 to 5730 do writeln('<li>',i,gutlist[i],matr[i*5730+(i)],'/',matr[i*5730+(3)]);

    writeln('donereadmatrix');
    try                try
         Rewrite(binf, length(matr)*4);
         Blockwrite(binf, matr[0], 1);except writeln('nononowritematr');end;
       finally
         writeln('writtem');
         CloseFile(binf);end;
end;

   procedure getbigs(var tosort:pword;bigs,bigvals:pword;w:word;sl:tstringlist);
   var i,j,posi,fils:word;d:boolean;test:longword;
   begin
     //exit;
     //d:=false;//w=21;
    test:=99265;
    //if d then writeln('+++',word((tosort)^),sl[w],'<hr>');
    fillchar(bigs^,32*2*2,0);
    fillchar(bigvals^,32*2*2,0);
    //if w=test then writeln(^j,'!!! ',sl[w],'','=');//,(tosort+i)^,' !');

    //if d then for i:=0 to 50 do if (tosort+i)^>0 then writeln(i,sl[i],' <b>',i,'=',(tosort+i)^,'</b>');// else writeln(sl[i]);
    try
    for i:=0 to 5730 do
    begin
     if i=w then continue;
      //if w=test then if (tosort+i)^>bigvals[31] then begin write(^j,'###',(tosort+i)^,' !');   for j:=0 to 31 do write(' ',(bigvals+j)^);end;
      try
      posi:=32*2;//fils:=0;
      if (tosort+i)^>0 then //(bigvals+10)^ then
      begin
      for j:=0 to 63 do
       begin
        //if w=17 then write(' ? ',(bigvals+j)^);
        //if d then writeln(' /',j,'.',(bigvals+j)^,'/ ');//,(tosort+i)^>(bigvals+j)^);
        if (tosort+i)^>(bigvals+j)^ then begin //if d then writeln(j,'.',(bigs+j)^);
          if w=test then writeln(' !',posi);posi:=j;break;end;
       end;
      end;
      except writeln('failbigs1:',w);end;
      try
      //if w=I THEN WRITE(^J,SL[I],POSI,'/',(TOSORT+i)^,': ');
      if posi<64 then
      begin
       //fils:=fils+1;
       try
       move((bigs+posi)^,(bigs+posi+1)^,(63-posi)*2);
       except writeln('faila:',w,'/',posi);end;try
       move((bigvals+posi)^,(bigvals+posi+1)^,(63-posi)*2);
       except writeln('failb:',w,'/',posi);end;try
       move(i,(bigs+posi)^,2);
       except writeln('faild:',w,'/',posi);end;try
       move((tosort+i)^,(bigvals+posi)^,2);
       except writeln('failg:',w,'/',posi);end;
      end;
      except writeln('failbigs2:',w,'/',posi);end;
    end;
    except writeln('failbigs:::','@',w);end;
    //WRITE('/',sl[bigs^],bigvals^,': ');

end;



procedure tsynonyms.gutsparse;
var //instr:tfilestream;
    prevs:array[0..31] of word;
   i,j,k,m:longword;
   w,ocs,rowoc:longword;
   rel:double;
   matr:array of longword;
   relmatr:array of word;   //'standardized'
   gutlist:tstringlist;
   ppp,  sss,vvv:pword;
   bigvars,bigvals:array[0..63] of word;
   sparmat:array of word;
   sparf,binf:file;
   begin
    writeln('gutsparse');
    fillchar(prevs,sizeof(prevs),0);
    gutlist:=tstringlist.create;
    gutlist.sorted:=true;
    gutlist.loadfromfile('gutsanat.ansi');
    setlength(matr,5730*5730);
    setlength(sparmat,5730*64*2);
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

     writeln('donereadmatrix',gutlist.count);
        writeln(gutlist.indexof('olla'), gutlist.indexof('aallokko'));
       // for i:=0 to 5730 do writeln('<li>',i,gutlist[i],matr[i*5730+(i)],'/',matr[i*5730+(3)]);

     //exit;
     //readln;
    for i:=0 to 5728 do //5728 do
    begin
     rowoc:=matr[i*5730+i];
    // writeln('<li><li>',i,':',gutlist[i],':',matr[i*5730+i]);
     //write(' ',matr[^j,^j,gutlist[i],rowoc,':');
     for j:=0 to 5728 do
     begin
      try
      ocs:=matr[i*5730+j];
      //writeln(gutlist[j],ocs,'/',matr[j*5730+j],'=',round(ocs*100000/matr[j*5730+j]));
      //if ocs>10000 then writeln(gutlist[i],'_',gutlist[j],ocs);
      //continue;
       //rel:=matr[j*5730+j];
       //if ocs<3 then continue;
      except writeln('NO:',ocs,'/',matr[j*5730+j]);end;
       if ocs<2 then rel:=0 else
       if i=j then rel:=ocs div 10 else
       begin //rel:=((ocs)*10000) div (round(sqrt(rowoc*matr[j*5730+j])+1));
         try
         //rel:=(ocs*10000000/(matr[j*5730+j]*rowoc+1));
         rel:=(ocs*ocs*1000000)/(matr[j*5730+j]*rowoc+1);
         //rel:=(ln(rel+1));
         except writeln('toobig:',ocs,'/',matr[j*5730+j]);end;
           //if ocs>100 then if i<>j then     writeln(round(ocs*100000/matr[j*5730+j]));
       end;
       //if j=i then writeln(ocs,':',rel,' ');
       //rel:=200000*ocs div (rowoc*matr[j*5730+j]+1);
      //if j=4269 then
    //  if ocs>10 then    write(' ',ocs);

       //if rel>150 then write(ocs,gutlist[j],rel,' ');
       try
       relmatr[i*5730+j]:=round(rel);// div 5;
       // write(rel);
      except
        relmatr[i*5730+j]:= 65535;
        write('<li>fail:',i,'/',j,gutlist[i],':',gutlist[j],'=',ocs,'>',round(rel));end;
     end;
       //for j:=0 to 5728 do if relmatr[i*5730+j]>10 then writeln(gutlist[j], relmatr[i*5730+j],' ');
       //if i>50 then break;
       //continue;

     //if i=3034 then writeln('<h1>olla?',gutlist[i],matr[i*5730+i],'/',rowoc,'</h1>');
     //               mysyn[ps1*5730+ps2]:=mysyn[ps1*5730+ps2]+occurs+1;

    // procedure big16(var tosort,bigs:pword;bigvals:pword;w:word;sl:tstringlist);

    end;
    writeln('matrix standardized');
    for i:=0 to 5728 do
    begin
      try
     // sleep(100);
      sss:=pword(relmatr)+i*5730;
      //write(' ',gutlist[i],sss^,':');
      getbigs(sss,ppp,vvv,i,gutlist);
      except writeln('??',i,'failbigs',BIGVAlS[J]);end;
      TRY
     // for j:=0 to 31 do if bigvars[j]>0 then IF BIGVARS[J]< 5730 THEN write(' ',gutlist[bigvars[j]],bigvals[j]);
      //sparmat[(i*64)+1]:=relmatr[i*5730+(i)];    sparmat[i*64]:=i;
      bigvars[0]:=i;bigvals[0]:=relmatr[i*5730+(i)] div 1;
      for j:=0 to 63 do begin
       try
       sparmat[(i*64*2)+(j*2)]:=bigvars[j];
       sparmat[i*64*2+(j*2)+1]:=bigvals[j];
       except writeln('???');end;
       //if sparmat[(i*64)+(j*2)]>20 then
      end;
      //writeln(' ',gutlist[i],'/',gutlist[bigvars[0]],' //',bigvals[0],'//',gutlist[bigvars[1]],' //',bigvals[1]);
     except writeln('!!',i,':',j,'=',(i*64)+(j*2),'/',length(sparmat),'failbigs',BIGVAlS[J]);end;

    end;
    //exit;
    //for i:=0 to 5729 do if sparmat[i*64*2+1]>1000 then writeln('<li>',gutlist[i],matr[i*5730+(i)],'/',relmatr[i*5730+(i)],'/sp:',sparmat[i*64*2],':',sparmat[i*64*2+1]);
    try
    writeln('donematrxs');
    savebin(5730,5730,2,relmatr,'gutrel.mat');
    except writeln('failsaverel');end;

    writeln('DODODODOD');
    try
    begin
      try
      AssignFile(binf, 'gutspar.mat');  //ei onnistu tstrinlistill� varmaan blockwrite
      Rewrite(binf, 64*4);
      writeln('binsave:');
       for i:=0 to 5729 do //writeln(i*syncols,syns[i*syncols]);exit;
        begin // do
         try
          BlockWrite(binf, sparmat[i*64*2], 1);
         except on e:exception do writeln(e.message);end;
        // if i=3 then     for j:=0 to 31 do write(' ',gutlist[sparmat[i*64+j*2]],' ');//,':',sparmat[i*64+j*2+1],' ');
        end;
        writeln('binsaved');
      finally
        Closefile(binf);
        writeln('binclosed:');

       end;
      end;

    for i:=0 to  5730 do //if sparmat[i*64*2+1]>1000 then
      begin writeln('<li><li>:',i,';<b>',gutlist[i],'</b>:',sparmat[i*64*2+1]);
       for j:=1 to 63 do
       begin w:=sparmat[i*64*2+j*2];
       if (w<>5730)  then if sparmat[i*64*2+j*2+1]<00 then break else write(' ',gutlist[w],sparmat[i*64*2+j*2+1]);end;
      end;

    //savebin(5730,32,4,sparmat,'gutspar.mat');
    except writeln('failsavesparce');end;
    writeln('DODODODOD');
  end;

procedure tsynonyms.gutkerro;
   var i,j,k,m:word;
       we:longint;         cols:word;
       gutlist:tstringlist;binf:file;
       sparmat:array of word;
       hithits,ni,nj,nk,nij,njk,nik:longword;subi,subj,subk,subm:word;
   begin
     cols:=64;
     gutlist:=tstringlist.create;
     gutlist.loadfromfile('gutsanat.ansi');
     setlength(sparmat,5730*64*2);
     try
      //gutlist.insert(0,'.'); //
      AssignFile(binf, 'gutspar.mat');  //ei onnistu tstrinlistill� varmaan blockwrite
      Reset(binf, 64*4);
      //writeln('binread:',fn);
       for i:=0 to 5729 do //writeln(i*syncols,syns[i*syncols]);exit;
        begin // do
         try
          Blockread(binf, sparmat[i*64*2], 1);
           //IF I=3058  THEN write(^j^j,'*',i,gutlist[i],' ');
            //if i=3058 THEN for j:=0 to 31 do write(gutlist[sparmat[i*64+j*2]],' ');//,':',sparmat[i*64+j*2+1],' ');
          //end;
         except on e:exception do writeln(e.message);end;
        end;
        writeln('binread');
      finally
        Closefile(binf);
        writeln('binclosed:');

       end;

      //readbin(5730,32,4,sparmat,'gutspar.mat');;
     // exit;

      writeln('<ul>');
      for i:=1 to 57 do // 5729 do
      begin
        try
        ni:=sparmat[i*64*2+1];

       // for j:=0 to 31 do if bigvars[j]>0 then IF BIGVARS[J]< 5730 THEN write(' ',gutlist[bigvars[j]],bigvals[j]);
        write('<li>:',gutlist[i],':');//,'/',sparmat[i*64*2+1],'; ');
              //if i>2800 then //writeln(' ?',i,'/',sparmat[i*cols],':',sparmat[i*cols+1],'.',sparmat[i*cols+2],':',sparmat[i*cols+3],'.',sparmat[i*cols+4],':',sparmat[i*cols+5],' ');
        //if i>00 then   for j:=0 to 31 do IF sparmat[i*64+j*2]<5730 then write(gutlist[sparmat[i*64+j*2]],':',sparmat[i*64+j*2+1],' ');
                  //for j:=0 to 32 do write(' ',gutlist[sparmat[i*32+j*2]],':',sparmat[i*32+j*2+1],' ');
                 // for j:=0 to cols do write(i,'/',sparmat[i*32+j],':',sparmat[i*32+j+1],' ');
               if ni=0 then continue;
        for j:=1 to 63 do
        begin
         subj:=sparmat[i*64*2+j*2];
         nj:=  sparmat[i*64*2+j*2+1];
         nij:=sparmat[subj*64*2+1];
         hithits:=0;
         IF subj=5730 then continue;
         IF subj=i then continue;
         write(' ',gutlist[subj],' ');//,nj,'/');
         //continue;
         for k:=1 to 63 do
         begin
          subk:=sparmat[subj*64*2+k*2];
          njk:=sparmat[subj*64*2+k*2+1];
          if subk=5730 then continue;
          if subk=subi then begin write(' ');continue;end;
          //if subk=i then begin hithits:=hithits+nk;continue;write('<b> ',gutlist[subk],'</b>');continue;end;
          //if sparmat[subk]=i then hithits:=hithits+2;// writeln(i*64+(j*2),'/',length(sparmat)) else
          for m:=1 to 63 do
           begin
               try
               try subm:=sparmat[i*64*2+m*2];except write('!!',subj);end;
               if subm=5730 then continue;
               //if subj=subi then continue;
               //write(' ',gutlist[subk],' ');
               if subm=subk then begin hithits:=hithits+nij*njk*sparmat[i*64*2+m*2+1]; continue;write('<em>',gutlist[subk],'</em> ') end;
               except  write('??',subk);end;
           end;
           //write('</ul>');
          end;
          if hithits>10 then write('<b>',hithits div (ni*nj),'</b> ') else write('<em style="font-size:0.5 em">',gutlist[subj],hithits,'</em> ');
         //write('</ul>');
        end;

         //if i>00 then   for j:=0 to 31 do
         //if (hithits=0) then
         //write(' -',gutlist[subi]);
         //for k:=0 to 31 do write(' ',sparmat[subw*64+(k*2)]);
         //write(' ',gutlist[sparmat[(i*64)+(j*2)]],'=',  sparmat[i*64+(j*2)+1]);
       except writeln('!!',i,':',j,'=',(i*64)+(j*2),'/','fail!</b>');end;
       //write('</ul>');

      end;
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
  //assignfile(outfile,'gutx2.sums');//numeroina, tuplana, vaatii sorttaamisen my�hemmin
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
  //assignfile(outfile,'gutx2.sums');//numeroina, tuplana, vaatii sorttaamisen my�hemmin
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
  assignfile(outfile,'gutx2.fi');//numeroina, tuplana, vaatii sorttaamisen my�hemmin
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
  //assign(ifile,'sanatvaan.ansi');  //synonyymit/liittyv�t sanat
  //reset(ifile);
  assign(resfile,'sanatnum.ansi');  //synonyymit/liittyv�t sanat
  rewrite(resfile);
  assign(synfile,'syn_ok.ansi');  //synonyymit/liittyv�t sanat
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
   if psan>=0 then  //pit�is saada talteen my�s tieto synonyymien keskin�isist� yhteyksist�
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
   end else    //eka sana (jonka synonyymej� rivill� listataan) ei esiinny sanalistassa
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
        savebin(synsans,syncols,2,syns,'syn.bin');
        close(resfile);
        writeln('resclosed');
        close(synsetfile);
        writeln('synsetclosed');
  end;
end;
  {
 linehits:=tlist.create;
//inf:=tfilestream.create('wikithe.txt',fmopenread);  //synonyymit/liittyv�t sanat
//assign(inf,'gutsanat.iso');  //synonyymit/liittyv�t sanat
//assign(inf,'sense.nums');  //synonyymit/liittyv�t sanat
//assign(inf,'wikithe.ansi');  //synonyymit/liittyv�t sanat
assign(inf,'syn_allx.ansi');  //synonyymit/liittyv�t sanat
//assign(inf,'sanatall.arev');  //kaikki ei-yhdyssanat
reset(inf);
assign(synf,'syn_ok.ansi');  //synonyymit/liittyv�t sanat
rewrite(synf);
assign(sanaf,'sanat_ok.ansi');  //synonyymit/liittyv�t sanat
rewrite(sanaf);
assign(misfile,'testimiss.the');  //synonyymit/liittyv�t sanat
assign(numfile,'syn_ok.num');  //synonyymit/liittyv�t sanat
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
    //if sana<>'tyt�r' then continue;
    sana:=stringreplace(trim(sana),'_','',[rfReplaceAll]);
    sana:=stringreplace((sana),'-','',[rfReplaceAll]);

    if ekasana then prevsana:=sana;
    sana:=reversestring(sana);
    akon:='';
    //if sana='' then begin writeln(outf,'*****');continue;end else
    voksointu(sana,hakueietu,hakueitaka);
    if hakueitaka and hakueietu then   continue;   //autorit��risten harmiksi
    hakurunko:=taka((sana));
    hakukoko:=sana;
    hits:=0;
    hitnum:=etsiyks(hakurunko,akon,hakukoko,hakueietu,hakueitaka,nominit.sijat[0],nil,nil,hits);
    if hakurunko[1]='a' then
    //res:=res+
    if hitnum=0 then hitnum:= etsiyks(hakurunko,akon,hakukoko,hakueietu,hakueitaka,
    verbit.sijat[0],nil,nil,hits); //verb permuo p��ttyy "a"
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

