program testing;
type 
    user = record
    nama,umur:string;
    end;

    dataUsre = record
    n:integer;
    data:array[1..10] of user;
    end;
var
datausr: dataUsre;
temp:dataUsre;
begin
    datausr.n := 2;
    datausr.data[1].nama := 'iqbal';
    datausr.data[1].umur := '12';
    datausr.data[2].nama := 'samsul';
    datausr.data[2].nama := '13';
    temp := datausr;
    writeln(temp.n);
end.