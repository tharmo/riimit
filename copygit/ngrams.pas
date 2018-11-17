unit ngrams;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type tsimmat=class(tobject)
  rows,cols:word;
  vals,vars:array of word;

  kertotaulu:array of byte;
  slist:tstringlist;
  function haegramlist(luku:word;var sanums:tlist;sl:tstringlist;res:tlist):word;
  function kerro(luku:word;var sanums:tlist;sl:tstringlist;res:tlist):word;
  constructor create(r,c:word;fn:string;sl:tstringlist);
end;
type tsimisanat=class(tobject)
  matx:tsimmat;
  //simmat: arra
  infile,outfile:file;
  listfname:string;
  slist:tstringlist;
  constructor create(c:word;fn,sfn:string);
end;
implementation
 uses riimiutils,math,syno;

 function tsimmat.kerro(luku:word;var sanums:tlist;sl:tstringlist;res:tlist):word;
 var w,ss,sanum,sanz,maxi:word;
 begin
  maxi:=0;
  writeln('<h3>:kerro ',sl.count,'</h3>');
  cols:=64;
  for w:=58 to 60 do
  begin
    //sanz:=integer(sanums[w]);
    writeln('<li>',W,'.',sl[w+1],'/',sl[vars[w*cols]],vars[w*cols],':');
    for ss:=0 to 16  do
       if (vars[w*64+ss])=0 then break else
      write(sl[vars[w*64+ss]+1],vars[w*64+ss],' ');

      //    writeLN(slist[vars[W*64+33]],' /');//,vals[i*64+j],' ');
  end;
  setlength(kertotaulu,30000);
  writeln('<h3>:kerro ',luku,'</h3>');
  for w:=0 to sanums.count-1 do
  begin
    sanz:=integer(sanums[w]-1);
    writeln('<li>',sanz,sl[sanz+1],'/',sl[vars[sanz*cols]+1],':');
    for ss:=0 to luku do
    if vars[sanz*cols+ss]=0 then break else
    begin
      sanum:=integer(vars[sanz*cols+ss]+1);
      writeln(sanum,sl[sanum]);
      inc(kertotaulu[sanum]);
      maxi:=max(maxi,kertotaulu[sanum])
    end;
 end;
 writeln('<h1>max:',maxi,'</h1>');
 for w:=0 to 27551 do
 if kertotaulu[w]*5>maxi  then
 try
 writeln('<li>',sl[w],' ',kertotaulu[w]);
 except writeln('<li>,xxx:', sl[w]);end;
end;

function tsimmat.haegramlist(luku:word;var sanums:tlist;sl:tstringlist;res:tlist):word;
 var w,i,j,hit:integer;sanum:word;
 begin
   //listgrams;  exit;
   setlength(kertotaulu,30000);
   hit:=-1;
   for w:=0 to sanums.count-1 do
   begin
   sanum:=integer(sanums[w]);
    if res.indexof(tobject(pointer(sanum)))<0 then res.add(pointer(sanum));
    //sanum:=sanum-1;
   for i:=1 to luku do //cols-1 do
   if vals[sanum*(cols)+i]=0 then break
   else begin
    hit:=vars[(sanum-1)*cols+i];   //vitun zerobase
    if hit<0 then continue;
    if res.indexof(tobject(pointer(hit+1)))<0 then res.add(pointer(hit+1));

    //writeln('',hit)

    //writeln(',','#',sl[result+1],'/');
    end;
   end;
 end;

constructor tsimisanat.create(c:word;fn,sfn:string);
begin
slist:=tstringlist.create;
listfname:=sfn;
slist:=tstringlist.create;
slist.loadfromfile(listfname);
matx:=tsimmat.create(slist.count,c,fn,slist);

end;
constructor tsimmat.create(r,c:word;fn:string;sl:tstringlist);
vAR ii,I,J,jj,ci,cj,jval,n,biggest:WORD;
    tot,thisi,thisj,ij:longword;
    rap:string;
    //cous:array of byte;

begin
 slist:=sl;
 writeln('gosims:',slist.count,'*',r,'*',c);
 // setlength(cous,30001*30001);
  rows:=r;cols:=c;
  //setlength(vars,r*c);
  //setlength(vals,r*c);
  setlength(vars,30001*64);
  setlength(vals,30001*64);

  READbin(r,c,2,vars,fn+'.spar') ;
  READbin(r,c,2,vals,fn+'_v.spar') ;
  //fillchar(nvars[0],sizeof(nvars),0);
  //fillchar(nvals[0],sizeof(nvals),0);
  //for i:=1 to rows-1 do
  exit;
   for i:=1 to 200 do
  begin
    writeln(^j^j^j'<li>',slist[i],'#',vars[i*64],vals[i*64],':');
   for j:=1 to 64 do
    if vals[i*64+j]=0 then break else
    writeln(slist[vars[i*64+j]]);//,'#',vals[i*64+j],':');
  end;
end;
end.

