unit cluster;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type tsimmat=class(tobject)
  rows,cols:word;
  vals,vars:array of word;
  slist:tstringlist;
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
 // setlength(cous,30001*30001);
  rows:=r;cols:=c;
  setlength(vars,r*c);
  setlength(vals,r*c);

  READbin(r,c,2,vals,fn+'.spar') ;
  READbin(r,c,2,vars,fn+'.spar') ;
  //fillchar(nvars[0],sizeof(nvars),0);
  //fillchar(nvals[0],sizeof(nvals),0);
  for i:=1 to rows-1 do
   for j:=1 to cols-1 do
  //  write(^j^j^j'<li>',slist[i],'#',vals[i*64],':');
end;
end.

