unit nomutils;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;
type taste=record
   a:ansichar;
   f,t:ansistring;
end;
//  type tvhaku=record hakunen:string[15];sija:byte;takavok:boolean;end;
//type tvhakuset=array of tvhaku;

type tasteet=array[0..15] of taste;
const aste: tasteet=((a:'_';f:'';t:''),(a:'A';f:'kk';t:'k'), (a:'B';f:'pp';t:'p'), (a:'C';f:'tt';t:'t'), (a:'D';f:'k';t:'-'), (a:'E';f:'p';t:'v'), (a:'F';f:'t';t:'d'), (a:'G';f:'nk';t:'ng'), (a:'H';f:'mp';t:'mm'), (a:'I';f:'lt';t:'ll'), (a:'J';f:'nt';t:'nn'), (a:'K';f:'rt';t:'rr'), (a:'L';f:'k';t:'j'), (a:'M';f:'k';t:'v'), (a:'N';f:'s';t:'n'), (a:'O';f:'t';t:'-'));
//const paatteet:array[0..24] of ansistring=('','n','a','ssa','sta','*n','lla','lta','lle','na','ksi','tta','t','en','a','issa','ista','in','illa','ilta','ille','ina','iksi','itta','in');
//  [0,              ,     2,      ,       ,        5,     ,       ,       ,        9,     ,       ,       ,          13,       14,     ,        ,      17,      ,       ,     , 21]

const muotoja=76;luokkia=28;
//const lkavoks=array[0..
const konsonantit ='bcdfghjklmnpqrstvwxz'''; vokaalit='aeiouy‰ˆ';
const yhtlopsold:array[0..12] of ansistring=  ('','a' ,'n' ,'*n' ,'lle' ,'tta' ,'t' ,'a' ,'en' ,'in' ,'ille' ,'in','itta');
  function getastekons(a:ansichar;var vva,hko:ansistring):taste;
function hyphenfi(w:ansistring;tavus:tstringlist):ansistring;
procedure testsijat(MIDS:array of tstringlist);
function IFs(cond:boolean;st1,st2:ansistring):ansistring;
//function taka(st:ansistring):ansistring;
function takako(st:ansistring;var oliko:boolean):ansistring;
//function taka(st:ansistring):boolean;
//function etu(st:ansistring):ansistring;
function isdifto(c1,c2:ansichar):boolean;
function matchend(sa,en:ansistring):boolean;
function matchtavut(s1,s2:tstringlist):boolean;
type //tstringarrayp=^ansichar;
  sanastr=string[15];
function matchendvar(sa,en:ansistring;var alku:ansistring):boolean;
//FUNCTION STRTOARRAYREV(str:ansistring;arp:pointer):boolean;//array[0..15] of ansichar;

implementation
uses math;

{FUNCTION STRTOARRAYREV(str:ansistring;arp:tstringarrayp):boolean;//array[0..15] of ansichar;
var i,len:byte;//sp:^ansichar;
begin
 //p:=arp;
  len:=min(15,length(str));
  for i:=1 to len do
   (arp+i)^:=str[len-i+1];
  arp^:=ansichar(len);
end;
FUNCTION ARRAYREVtostr(str:sanastr;arp:tstringarrayp):boolean;//array[0..15] of ansichar;
var i,len:byte;sp:^ansichar;
begin
  move(
 len:=byte(arp^);
 if Len>0 then
     SetString(Result, PChar(@a[0]), Length(a))
   else
     Result := ''; sp:=arp;
  for i:=1 to len do
   str[len-i+1]:=(sp+i)^;
  //sp^:=ansichar(len);
end;}
function matchalkutavu(s1,s2:ansistring):boolean;
var i,j:integer;
begin
try
  result:=true;
  if (s1='') or (s2='') then exit;
  while pos(s1[1],konsonantit)>0 do delete(s1,1,1);
  while pos(s2[1],konsonantit)>0 do delete(s2,1,1);
  result:=s1=s2;
  //writeln(result,s1,s2);
  except   writeln('!!FAILEN:',s1,s2);end;
end;


function matchtavut(s1,s2:tstringlist):boolean;
var i,j,ldif,end1:integer;p:boolean;
begin
  RESULT:=TRUE;
  //writeln('<li>MMMM:',s1.commatext,'///',s2.commatext);
 // p:=s1.text=s2.text;
  ldif:=s1.count-s2.count;
    for j:=(s1.count-1) downto 2 do
      if j-ldif<2  then
      begin //writeln('(',j-ldif,'!)');
        break;
      end else
      begin
          //if s1[j]<>taka(s2[j-ldif]) then
          if s1[j]<>s2[j-ldif] then
           begin //write('{',J,s1[j],'!=',J-LDIF,s2[j-ldif],'}');
             result:=fALSE;
               //if p then
               //writeln('<li style="color:red">xxyy',s1.commatext,'/',s2.commatext,result);
             EXIT;end;
          // write(' [',J,s1[j],'=',J-LDIF,(s2[j-ldif]),']');
          end1:=j;
      end;
    try
     //writeln('<li>',s1.commatext,'///',s2.commatext);
     if (end1>1) and (end1-ldif-1>0) then
      result:=matchalkutavu(s1[end1-1],s2[end1-ldif-1]);
    //writeln('((',end1, s1[end1-1],'/',s2[end1-ldif-1],'))',result);
    except   writeln('fail:',end1-1,'[[',end1, ldif,']]',end1-ldif-1);
   end;
    //FOR J:=LENGTH(S1[)
end;
function wallop(a,l:ansistring):ansistring;
begin
  writeln('<li  style="color:green">',a,length(a),'=',l,length(l),'</li>');
   result:=('<h4><b style="color:red">///'+a+'</span> / <span style="color:blue">'+l+'</b></h4>');
end;
function matchendvar(sa,en:ansistring;var alku:ansistring):boolean;
VAR I,J:INTEGER;lendif,posi:integer;
BEGIN
 try
  try
 result:=true;
 en:=trim(en);
 lendif:=length(sa)-length(en);  //alet4  t1 -> 3
 //write(' ',length(sa),'-',length(en),'==',lendif);
  if en='' then begin alku:=sa; //if pos('lau',sa)>0 then writeln('xxx',alku);
     exit;end;
  if sa='' then begin result:=false;alku:='';exit;end;

 if lendif<0 then  begin result:=false;alku:='';exit;end;
 posi:=length(en);
 while posi>0 do
 begin
  if sa[posi+lendif]<>en[posi] then begin result:=false;break;end;
  posi:=posi-1;
 end;
 //if result then //write('(('+sa,'?',en,result,'))');

 finally  if result then begin alku:=copy(sa,1,lendif);//try writeln(wallop(alku,copy(sa,lendif+1))); except writeln('!!!');end;
 end;end;
 //if en='' then if pos('lau',sa)>0 then writeln('Z',alku,result);
 except writeln('###FAILMATCHEND');end;
END;

function matchend(sa,en:ansistring):boolean;
VAR I,J:INTEGER;lendif:integer;
BEGIN
 try
 result:=true;
 if en='' then exit;
 if sa='' then exit;

 lendif:=length(sa)-length(en);  //alet4  t1 -> 3
 for i:=length(en) downto 1 do
  if sa[i+lendif]<>en[i] then begin result:=false;break;end;
 except writeln('###FAILMATCHEND');end;

END;

  function IFs(cond:boolean;st1,st2:ansistring):ansistring;
       begin
        if cond then result:=st1 else result:=st2;
       end;
  function etu(st:ansistring):ansistring;
  var i:byte;
  begin
   for i:=1 to length(st) do
    if st[i]='a' then st[i]:='‰' else
   if st[i]='o' then st[i]:='ˆ' else
   if st[i]='u' then st[i]:='y';// else st[i]:=st[i];
   result:=st;
  end;

  function taka(st:ansistring):ansistring;
  var i:byte;st2:ansistring;
  function c(s:ansichar):ansichar;
  begin
      if pos(s,'aou')>0 then begin result:=s;end else
      if s='‰' then result:='a' else
      if s='ˆ' then result:='o' else
      if s='y' then result:='u'  else result:=s;
   end;
  begin
   result:='';
   for i:=1 to length(st) do st[i]:=c(st[i]);
   result:=st;
   //write(result,' ');
  end;
  function takako(st:ansistring;var oliko:boolean):ansistring;
  var i:byte;st2:ansistring;
  function c(s:ansichar):ansichar;
  begin
      if pos(s,'aou')>0 then begin oliko:=true;result:=s;end else
      if s='‰' then result:='a' else
      if s='ˆ' then result:='o' else
      if s='y' then result:='u'  else result:=s;
   end;
  begin
   oliko:=false;result:='';
   for i:=1 to length(st) do st[i]:=c(st[i]);
   result:=st;
   //write(result,' ');
  end;

function isdifto(c1,c2:ansichar):boolean;
 begin
  result:=false;
  if c1=c2 then result:=true else                       //arv  i o i da
  case c1 of
   'a': if pos(c2,'iu')>0 then result:=true;
   'e','i': if pos(c2,'ieuy')>0 then result:=true;
   'o','u': if pos(c2,'iuo')>0 then result:=true;
   'y','ˆ': if pos(c2,'iyˆ')>0 then result:=true;
   '‰': if pos(c2,'iy')>0 then result:=true;
  end;
 end;

function getastekons(a:ansichar;var vva,hko:ansistring):taste;
var i,hit:byte;
begin try
  hit:=16;
  //result:='';
  for i:=1 to 15 do if aste[i].a=a then hit:=i;
  //WRITELN(':',A,'|',HIT,';');
  if hit=16 then result:=aste[0] else result:=aste[hit];
  if result.t='-' then result.t:='';
  hko:=result.t;vva:=result.f;
  if result.f='' then exit;
  if length(result.f)=2 then
  begin
    vva:=result.f[2];
    if length(result.t)=2 then hko:=result.t[2]  // 2/2 tapauksissa eka kons aina sama (ng/mm, mp,mm,..)
    else hko:='';  // 2-1 tapauksissa eka kons aina sama (kk/k, pp,p,..)
    exit;
  end;{ else if length(result.f)=1 then //always true at this point
  begin
    if length(result.t)=heikko:='';

  end; }
  except writeln('<tr><td><em>GETASTE (',a,'/',vva,'/',hko,')</em></td></tr>');end;
end;
function hyphenfi(w:ansistring;tavus:tstringlist):ansistring;
 //var tavus:tstringlist;
   var i,k,len,vpos:integer;hy,vocs,alkkon:ansistring;ch,chprev:ansichar;lasttag:ansistring;haddif:boolean;

 begin
   //avucount:=0; //global,  temp trickstery
   tavus.clear;
   len:=length(w);
  //writeln('<li>',w,': ');
  if len=0 then exit;
  result:='';//w[len];
  chprev:=' ';//w[len];   //o
  haddif:=false;
  alkkon:='';
  //write(^j,w,':');
  if (pos(w[1],konsonantit)>0) then
  for i:=2 to 3 do if (pos(w[i],konsonantit)>0) then alkkon:=alkkon+w[i-1] else break;
  //if alkkon<>'' then write('\',alkkon);
  if alkkon<>'' then w:=ansilowercase(copy(w,length(alkkon)+1,99));

  len:=length(w);
  //write('#',w, '/',alkkon,'@');
   //  a-iu,e-ieuy, i-ieuy,o-iou,u-iou

  for i:=len downto 1 do
  begin
     ch:=w[i]; //d  kons alkaa uuden tavun paitsi jos ed=kons
     //if i=1 then if alkkon<>'' then begin tavus.insert(0,alkkon);end;
     if (pos(chprev,vokaalit)>0) then  //jos ed on vokaali
     begin        //a ie  prev:e nyt:i  ie on dift
       //if (pos(ch,konsonantit)>0) then  begin haddif:=false;result:=result+'-'+ch+hy+'-'+result;addtolist(hyps,ch+hy,true);hy:='';ch:=' ';end
       if (pos(ch,konsonantit)>0)  then  begin haddif:=false;result:=result+'-'+ch+hy;tavus.insert(0,ch+hy);hy:='';ch:=' ';end
       //else if (haddif) then begin result:=hy+'+'+result;addtolist(hyps,hy,true);hy:=ch;end
       else  if haddif then begin haddif:=false;result:=result+'-'+hy;tavus.insert(0,hy);hy:=ch end
       else
       if (not isdifto(ch,chprev)) then //or  ((i>1) and (pos(w[i-1],vokaalit)>0)) then //kolm vok p√§tks aina kaksi vikaa?                     //  as-il a a is | os
       //else if (isdifto(ch,chprev)) then //or  ((i>1) and (pos(w[i-1],vokaalit)>0)) then //kolm vok p√§tks aina kaksi vikaa?                     //  as-il a a is | os
       begin
         //result:=hy+'+'+result;addtolist(hyps,hy,true);hy:=ch; //chprev:='y';//                     //  as-il a a is | os
         result:=result+'+'+hy+'+';tavus.insert(0,hy);hy:=ch; //chprev:='y';//                     //  as-il a a is | os
       end else  //diftongi, mutta tulossa viel√§ yksi vokaali
        if ((i>1) //and (pos(w[i-1],vokaalit)>0))
         and (isdifto(w[i-1],ch))) then begin
          result :=result+'+'+hy+'+';tavus.insert(0,hy);hy:=ch; //chprev:='y';//                     //  as-il a a is | os
        end else
        begin haddif:=true;hy:=ch+hy;
        end; //ignoroi kolmoiskons - mukana vain ei-yhd.sanojen perusmuodot,
    end else hy:=ch+hy;
     //if i=1 then begin result:=hy+'_'+result ;addtolist(hyps,hy,true);end else
     if i=1 then begin result:=result+'_'; if hy<>'' then tavus.insert(0,hy);end else
    chprev:=ch;
     //if i=1 then addtolist(hyps,copy(alkkon,length(alkkon)-1,length(alkkon))+hy,true);
     //if hy<>'' then
     //if pos(chprev,vokaalit)>990 then result:=chprev+'-'+result
     //else result:=chprev+result;
  end;

  //if alkkon<>'' then tavus[tavus.count-1]:=alkkon+tavus[tavus.count-1];  //ei n√§in kun sanoja rakennellaan - alkukonsontit talletaan sanan tietoihin, ei ekaan tavuun
  //if alkkon<>'' then tavus[0]:=alkkon+tavus[0];  //ei n√§in kun sanoja rakennellaan - alkukonsontit talletaan sanan tietoihin, ei ekaan tavuun
  if alkkon<>'' then tavus.insert(0,alkkon+'')
  else tavus.insert(0,'');//  tryin this .. maybe breaks something
  result:=alkkon+'_'+result;
  //writeln('**',hy,':::',alkkon);
  {ch:=w[1];
  if (pos(ch,konsonantit)>0) and (pos(chprev,konsonantit)>0) then
  begin
  for i:=2 to min(3,len) do if result[i]='-' then delete(result,i,1);
  end;  //result:=ch+''+result;
  //writeln('<hr/>');
  }
   result:=tavus.commatext;
  //tavus.free;
 end;

procedure testsijat(MIDS:array of tstringlist);
var x,lu,s1,s2,i:integer;sims:array[0..12] of array[0..12] of integer;
  yhts:array[0..12]  of string;
  function mend(w,e:ansistring):ansistring;
  var i,lendif,mis:integer;
  begin
   result:=e;
   lendif:=length(w)-length(e);
   //writeln(' \',e,'|',w,'=',lendif);
   for i:=length(e) downto 1 do
     if e[i]<>w[i+lendif] then
     begin
        result:=copy(e,i);
        break;
     end;
   //writeln(' &nbsp;&nbsp;',e,'|',w,'=',result);
  end;
begin
  fillchar(sims,sizeof(sims),0);
  writeln('<h3>listaamuodot</h3>');
  writeln('<hr>');
   {for s1:=0 to 12 do
   begin
     yhts[s1]:=mids[1][s1];
    //for s2:=0 to 11 do
    begin
      for lu:=0 to 49 do
        begin
          //if mids[lu][s1]<>mids[lu][s2] THEN sims[s1,s2]:=sims[s1,s2]+1;// else sims[s1,s2]:=sims[s1,s2]+1;
         try
          yhts[s1]:=mend(mids[lu][s1],yhts[s1]);except writeln('<li>miss:',lu,'*',s1);end;
          //write(' .',s1,s2);
        end;
     end;
    end;}
   writeln('<hr>yhtloput<li>');

   for s1:=0 to 22 do     WRITELN(',',paatteet[s1]);
   writeln('<hr>keskij‰m‰t<table border="1">');
   for lu:=0 to 49 do
   begin
     writeln('<tr><td>',lu+1,'</td>');//yhts[s1]:=mids[1][s1];
     for s1:=0 to 12 do
     begin
        begin
          //if mids[lu][s1]<>mids[lu][s2] THEN sims[s1,s2]:=sims[s1,s2]+1;// else sims[s1,s2]:=sims[s1,s2]+1;
          writeln('<td>',copy( mids[lu][s1],1,length(mids[lu][s1])-length(paatteet[s1])),' ',paatteet[s1],'</td>');
        end;
     end;
     write('</tr>');
    end;
   write('</table>');
   for lu:=0 to 49 do
   begin
     writeln('<li>',lu+1,',');//yhts[s1]:=mids[1][s1];
     for s1:=0 to 12 do
     begin
        begin
          //if mids[lu][s1]<>mids[lu][s2] THEN sims[s1,s2]:=sims[s1,s2]+1;// else sims[s1,s2]:=sims[s1,s2]+1;
          writeln(copy( mids[lu][s1],1,length(mids[lu][s1])-length(paatteet[s1])),',');
          //write(' .',s1,s2);
        end;
     end;
    end;
  WRITELN('<TABLE border="1"><tr><td>X</td>');
  for s1:=0 to 11 do     WRITELN('<TD><B>',S1,mids[0][s1],'</B></TD>');
  WRITELN('</TR>');
  for s1:=0 to 11 do
  BEGIN
    WRITELN('<TR><TD><B>',S1,mids[0][s1]+'</B></TD>');
    for s2:=0 to 11 do
    WRITELN('<TD>',sims[s1,s2],':',yhts[s1],'</TD>');
    WRITELN('</TR>')
  END;
        WRITELN('</Table>')

end;


end.


rocedure test;
var sfile,mfile:textfile;Ms,mls:tstringlist;sana,runko,lka,prevlka,itesana,av,v,h,lopvok,lopkon:ansistring;

osa:byte;
i,j,k,lknum:integer;
luomuo:array[0..50] of tstringlist;
tavus:tstringlist;
ast:taste;
thisvahva:boolean;
begin
  tavus:=tstringlist.create;
  writeln('<table border="1">');
  MS:=TSTRINGLIST.CREATE;
  ms.loadfromfile('muodot2.lst');
  for i:=0 to ms.count-1 do
  begin
     writeln('<tr><td>',i+1,'</td>');
     luomuo[i]:=tstringlist.create;
     luomuo[i].commatext:=ms[i];
     try
     luomuo[i].delete(0);
     //luomuo[i].delete(0);
     writeln('<li>',i);
     except end;
     for j:=0 to luomuo[i].count-1 do
     begin
        luomuo[i][j]:=trim(luomuo[i][j]);
        if pos('/',luomuo[i][j])>0 then  //it never is,
          luomuo[i][j]:=trim(copy(luomuo[i][j],1,pos('/',luomuo[i][j])-1))
        else luomuo[i][j]:=trim(luomuo[i][j]);
       writeln('<td>',luomuo[i][j],'</td> ');
     end;
     writeln('</tr>');

  end;
  writeln('</table>');
 ifs(true,'','');

 assign(sfile,'nomosa.lst');
 reset(sfile);
 i:=0;
 writeln('<table border="1">');
 while not eof(sfile) do
 begin
    readln(sfile,sana);
    osa:=0;
    lka:='';
    itesana:='';
    av:='';
    for j:=1 to length(sana) do
    if sana[j]=' ' then osa:=osa+1 else
    case osa of
       0: lka:=lka+sana[j];
       1: av:=av+sana[j];
       2: itesana:=itesana+sana[j];
    end;
    ast:=getastekons(av[1],v,h);
    //hyphenfi(itesana,tavus);
    lknum:=strtointdef(lka,999);
   if lka<>prevlka then
   begin
       writeln('<tr style="height:3em"><td style="display:inline-block;width:8em;margin-top:3em"><b>',lknum,'</td> </b>:</td> ');
       for j:=0 to luomuo[lknum-1].count-1 do write(' <td><b> ',luomuo[lknum-1][j],'</b></td> ');
        writeln('</tr>');
   end;
   prevlka:=lka;
   lopvok:='';
   for j:=length(itesana) downto 0 do if pos(itesana[j],vokaalit)>0 then begin lopvok:=itesana[j]+lopvok;end else break;
   if v='' then    for j:=length(itesana) downto 1 do if pos(itesana[j],vokaalit)<1 then begin v:=itesana[j];h:=v;break; end;
   runko:=copy(itesana,1,length(itesana)-length(v+lopvok));
   writeln('<tr><td>',av,'<b> ',itesana,' [',v,'|',h,']',lopvok,'</b>:</td> ');
   for j:=0 to luomuo[lknum-1].count-1 do
   if i<32 then
    begin
        //F aita: 	0 ai.t	1 ai.ta	2 ai.tn	3 ai.tan	4 ai.dlle	5 ai.dtta	6 ai.tt	7 ai.toja	8 ai.tain	9 ai.toihin	10 ai.toille	11 ai.toin	12 ai.doitta	13 ai.t
        if j in [2,4,5,6,10,11,12] then thisvahva:=false else thisvahva:=true;
       write('<td>',runko,'<b>',ifs((lknum>31)=thisvahva,v,h),'</b>',lopvok,'<b>',ansireplacetext(luomuo[lknum-1][j],'*',lopvok),'</b>.',yhtlops[j],'</td>');//;,AV,v,h, ' ');
    end
   else
   begin

  end;
      writeln('</tr>');
   i:=i+1;
 end;
 writeln('</table>');
end;
