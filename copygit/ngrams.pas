unit ngrams;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type tsimmat=class(tobject)
  rows,cols:word;
  vals,vars:array of word;

  kertotaulu:array of word;
  slist:tstringlist;
  procedure list(sl:tstringlist);
  function haegramlist(luku:word;var sanums:tlist;sl:tstringlist;res:tlist):word;
  function kerro(luku:word;var sanums:tlist;sl:tstringlist;res:tlist):tlist;
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

 procedure tsimmat.list(sl:tstringlist);
 var i,j:word;
 begin
   for i:=5190 to 5200 do
   begin
      writeln('<li>',i,'<b>',sl[i+1],'</b>::');
      for j:=1 to cols-1 do if vars[(i)*cols+j]=0 then break else writeln(sl[vars[i*cols+j]+1],vals[i*cols+j]);
   end;
 end;
 function tsimmat.kerro(luku:word;var sanums:tlist;sl:tstringlist;res:tlist):tlist;
 var w,ss,sanum,sanz,maxi:word;
 begin
  maxi:=0;
  writeln('<h3>:kerro ',sl.count,'</h3>');
  cols:=64;
  for w:=70 to 60 do
  begin
    //sanz:=integer(sanums[w]);
    writeln('<li>',W,'.',sl[w+1],'/',sl[vars[w*cols]],vars[w*cols],':');
    for ss:=0 to 16  do
       if (vars[w*64+ss])=0 then break else
      write(sl[vars[w*64+ss]+1],vars[w*64+ss],' ');

      //    writeLN(slist[vars[W*64+33]],' /');//,vals[i*64+j],' ');
  end;
  setlength(kertotaulu,30000);
  //writeln('<h3>:kerro ',luku,'</h3>');
  for w:=0 to sanums.count-1 do
  begin
    sanz:=integer(sanums[w]-1);
    //writeln('<li>',sl[sanz+1]);
    for ss:=1 to luku do
    if vars[sanz*cols+ss]=0 then break else
    begin
      sanum:=integer(vars[sanz*cols+ss]+1);
      if sanum>=24555 then continue;
      try
      //writeln(sanum);//,sl[sanum]);
      kertotaulu[sanum]:=kertotaulu[sanum]+integer(vals[sanz*cols+ss])+1;
      //if maxi<kertotaulu[sanum] then writeln(sl[sanz+1],'/',sl[vars[sanz*cols+ss]+1],':');
      maxi:=max(maxi,kertotaulu[sanum]);
      except writeln('FAILW:',sanz,'/',sanum);//,sl[sanz+1],'/',sl[vars[sanz*cols]+1],':');
      end;
    end;
 end;
 writeln('<h1>max:',maxi,'</h1>');
 for w:=0 to 27551 do
 if kertotaulu[w]*10>maxi  then
 try
 writeln('<li>;;',sl[w],' ',kertotaulu[w]);
 res.add(tobject(pointer(w)));
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

   writeln('<b>',sl[sanum],'</b>');
    //if res.indexof(tobject(pointer(sanum)))<0 then
    res.add(pointer(sanum));
    //sanum:=sanum-1;
    //writeln('<li>',i,'<b>',sl[i+1],'</b>::');
    //for j:=1 to cols-1 do if vars[(i)*cols+j]=0 then break else writeln(sl[vars[i*cols+j]+1],vals[i*cols+j]);
   for i:=1 to luku do //cols-1 do
   if vars[(sanum-1)*cols+i]=0 then continue
   else begin
    hit:=vars[(sanum-1)*cols+i];   //vitun zerobase
    //writeln(sl[hit+1],vals[(sanum-1)*cols+i]);
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

