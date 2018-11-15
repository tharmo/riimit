unit ngrams;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type tsimmat=class(tobject)
  rows,cols:word;
  vals,vars:array of word;
  slist:tstringlist;
  function haegramlist(luku:word;var sanums:tlist;sl:tstringlist;res:tlist):word;
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
 uses riimiutils,math;

 function tsimmat.haegramlist(luku:word;var sanums:tlist;sl:tstringlist;res:tlist):word;
 var w,i,j,hit:integer;sanum:word;
 begin
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
    writeln('',hit)

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
   for i:=1000 to 2000 do
  begin
    write(^j^j^j'',slist[i],'#',vars[i*64],vals[i*64],':');
   for j:=1 to 64 do
    if vals[i*64+j]=0 then break else
    write(slist[vars[i*64+j]],'#',vals[i*64+j],':');
  end;
end;
end.

