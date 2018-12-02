program tugas_besar;
uses crt;

const nMax = 100;
type
        
    user = record
    idUser:integer;
    noHP:string;
    nama,regional,email,password:string;
    end;
     posting = record
    idPosting,idPenulis,idGroup:integer;
    tema,isi,judul:string;
    end; 

    memberGroup = record
    idUser:integer;
    end;

    group = record
    idGroup,jumlahMember:integer;
    namaGroup:string;
    memberList: array [1..nMax] of memberGroup;
    end;

    arrUser = record
    data:array [1..nMax] of user;
    N: integer;
    end;

    arrGroup = record
    data:array [1..nMax] of group;
    N: integer;
    end;

    arrPosting = record
    data:array [1..nMax] of posting;
    N: integer;
    end;



var
    decision:char;   
    dataUser : arrUser;
    dataPosting : arrPosting;
    dataGroup : arrGroup;
    status : boolean;

    // session
    s_idUser : integer;
    s_idGroup : integer;
    //end session
    function loginBool(email,password:string):integer;
    var 
        i,status : integer;
    begin
        i:= 1; 
        status:= -1;
        while ( (i <= nMax) and (status = -1)) do
        begin
            if(dataUser.data[i].email = email) and (dataUser.data[i].password = password) then
                status := i;
        i:= i+1;
        end;
        if ((email = '') and (password = '')) then
            status := -2;
        loginBool := status;
    end;
    function getNamaPenulis(idPenulis:integer;dataUser:arrUser):string;
    var 
        i:integer;
    begin
        i:=1;
        while (i<= dataUser.N) do 
        begin
            if(dataUser.data[i].idUser = idPenulis) then
                getNamaPenulis:= dataUser.data[i].nama;
        i:= i + 1;
        end;
    end;
    procedure cloneDataGoup(dataGroup:arrGroup;var tempDataGroup:arrGroup);
    begin
        tempDataGroup:= dataGroup;
    end;
    procedure sortingDataGroup(var dataGroup:arrGroup;param:string);
    var
        pass,i:integer;
        tempData:group;
        tempInt:integer;
    begin
        pass := 1;
        if(param = 'jumlahmemberterendah') then
        begin            
            while(pass <= dataGroup.N - 1) do
            begin            
                i:= pass + 1;
                tempData := dataGroup.data[i];
                tempInt := dataGroup.data[i].jumlahMember;
                while ((i > 1) and (tempInt < dataGroup.data[i-1].jumlahMember)) do
                begin
                    dataGroup.data[i] := dataGroup.data[i-1];
                    i:= i -1;
                end;
                dataGroup.data[i] := tempData;
                pass := pass + 1;
            end;
        end
        else if(param = 'jumlahmemberterbesar') then
        begin            
            while(pass <= dataGroup.N - 1) do
            begin            
                i:= pass + 1;
                tempData := dataGroup.data[i];
                tempInt := dataGroup.data[i].jumlahMember;
                while ((i > 1) and (tempInt > dataGroup.data[i-1].jumlahMember)) do
                begin
                    dataGroup.data[i] := dataGroup.data[i-1];
                    i:= i -1;
                end;
                dataGroup.data[i] := tempData;
                pass := pass + 1;
            end;
        end;
    end;
    function getindexGroup(idGroup:integer;dataUser:arrUser;dataGroup:arrGroup):integer;
    var 
        i:integer;
    begin
        i:=1;
        status := true;
        while ((i<= dataGroup.N) and (status)) do 
        begin
            if(dataGroup.data[i].idGroup = idGroup) then
            begin
                getindexGroup:= i;
                status := false;
            end;
        i:= i + 1;
        end;
    end;
    function validationRegister(email:string):boolean;
    var 
        status: boolean;
        i : integer;
    begin
        i:= 1; 
        status:= true;
        while ( (i <= dataUser.N) and (status = true)) do
        begin
            if(dataUser.data[i].email = email) then
                status := false;
        i:= i+1;
        end;
        validationRegister := status;
    end;
    function getIdByEmail(dataUser:arrUser;email:string):integer;
    var 
        status: boolean;
        i : integer;
    begin
        i:= 1; 
        status:= true;
        while ( (i <= dataUser.N) and (status = true)) do
        begin
            if(dataUser.data[i].email = email) then
            begin
                getIdByEmail := i;
                status := false;
            end;
        i:= i+1;
        end;
    end;
    function pilihGroup(userID,idGroup:integer;dataGroup:arrGroup):boolean;
    var
        status:boolean;
        i:integer;
    begin
        i:= 1;
        status:= false;
        while(i <= dataGroup.N) do
        begin
            if(dataGroup.data[idGroup].memberList[i].idUser = userID) then
                status := true;
            i:= i + 1;
        end;
        pilihGroup:= status;
    end;
    function register(email,password,nama,regional,noHP:string):boolean;
    var
        idx:integer;
    begin
        if(validationRegister(email)) then
        begin
            idx := dataUser.N;
            dataUser.data[idx+1].idUser := idx + 1;
            dataUser.data[idx+1].email := email;
            dataUser.data[idx+1].password := password;
            dataUser.data[idx+1].regional := regional;
            dataUser.data[idx+1].nama := nama;
            dataUser.data[idx+1].noHP := noHP;
            dataUser.N := idx +1;
            register := true;
        end
        else
            register:= false;
    end;
    procedure listgroup(idUser:integer;dataUser:arrUser;dataGroup:arrGroup);
    var
        i,c:integer;
    begin
        i:= 1;
        while(i <= dataGroup.N) do
        begin
            c:= 1;
            while(c <= dataGroup.data[i].jumlahMember) do
                begin
                    if(dataGroup.data[i].memberList[c].idUser = idUser) then
                        writeln(dataGroup.data[i].namaGroup,'(',dataGroup.data[i].idGroup,')(',dataGroup.data[i].jumlahMember,' Member)');
                c:= c + 1;                 
                end;
            i:= i + 1;
        end;
    end;

    procedure cariPostingan(idGroup:integer;dataGroup:arrGroup;dataPosting:arrPosting;param,paramMain:string);
    var 
        idPenulis,i,idUserEmail:integer;
    begin
        if (param = 'email') then
            begin
            i := 1;
            idUserEmail:= getIdByEmail(dataUser,paramMain);
            while (i <= dataPosting.N) do
            begin
                if(dataPosting.data[i].idGroup = idGroup) and (dataPosting.data[i].idPenulis = idUserEmail) then
                    begin
                    idPenulis:= dataPosting.data[i].idPenulis;
                    writeln('========================');
                    writeln('ID Posting :',dataPosting.data[i].idPosting);
                    writeln('Penulis :',getNamaPenulis(idPenulis,dataUser));
                    writeln('Tema :',dataPosting.data[i].tema);
                    writeln('Judul :',dataPosting.data[i].judul);
                    writeln('Isi :');
                    writeln(dataPosting.data[i].isi);
                    writeln('========================');
                    end;
                i:= i + 1;
            end;
            end
        else if(param = 'tema') then
            begin
            i := 1;
            while (i <= dataPosting.N) do
            begin
                if(dataPosting.data[i].idGroup = idGroup) and (dataPosting.data[i].tema = paramMain) then
                begin
                    idPenulis:= dataPosting.data[i].idPenulis;
                    writeln('========================');
                    writeln('ID Posting :',dataPosting.data[i].idPosting);
                    writeln('Penulis :',getNamaPenulis(idPenulis,dataUser));
                    writeln('Tema :',dataPosting.data[i].tema);
                    writeln('Judul :',dataPosting.data[i].judul);
                    writeln('Isi :');
                    writeln(dataPosting.data[i].isi);
                    writeln('========================');
                end;
                i:= i + 1;
            end;
            end;
    end;

    procedure postinganList(idGroup:integer;dataGroup:arrGroup;dataPosting:arrPosting;waktu:string);
    var 
        idPenulis,i:integer;
    begin
        if (waktu = 'terbaru') then
            begin
            i := dataPosting.N;
            while (i >= 1) do
            begin
                if(dataPosting.data[i].idGroup = idGroup) then
                begin
                    idPenulis:= dataPosting.data[i].idPenulis;
                    writeln('========================');
                    writeln('ID Posting :',dataPosting.data[i].idPosting);
                    writeln('Penulis :',getNamaPenulis(idPenulis,dataUser));
                    writeln('Tema :',dataPosting.data[i].tema);
                    writeln('Judul :',dataPosting.data[i].judul);
                    writeln('Isi :');
                    writeln(dataPosting.data[i].isi);
                    writeln('========================');
                end;
                i:= i - 1;
            end;
            end
        else if(waktu = 'terlama') then
            begin
            i := 1;
            while (i <= dataPosting.N) do
            begin
                if(dataPosting.data[i].idGroup = idGroup) then
                    idPenulis:= dataPosting.data[i].idPenulis;
                    writeln('========================');
                    writeln('ID Posting :',dataPosting.data[i].idPosting);
                    writeln('Penulis :',getNamaPenulis(idPenulis,dataUser));
                    writeln('Tema :',dataPosting.data[i].tema);
                    writeln('Judul :',dataPosting.data[i].judul);
                    writeln('Isi :');
                    writeln(dataPosting.data[i].isi);
                    writeln('========================');
                
                i:= i + 1;
            end;
            end
        else if(waktu = 'self') then
            begin
            i := 1;
            while (i <= dataPosting.N) do
            begin
                if(dataPosting.data[i].idGroup = idGroup) and (dataPosting.data[i].idPenulis = s_idUser) then
                    idPenulis:= dataPosting.data[i].idPenulis;
                    writeln('========================');
                    writeln('ID Posting :',dataPosting.data[i].idPosting);
                    writeln('Penulis :',getNamaPenulis(idPenulis,dataUser));
                    writeln('Tema :',dataPosting.data[i].tema);
                    writeln('Judul :',dataPosting.data[i].judul);
                    writeln('Isi :');
                    writeln(dataPosting.data[i].isi);
                    writeln('========================');
                
                i:= i + 1;
            end;
            end;
    end;
    procedure lihatPostingan(idGroup:integer;dataUser:arrUser;dataGroup:arrGroup;dataPosting:arrPosting;waktu:string);
    begin
        clrscr;
        writeln('============================');    
        writeln('Postingan berdasarkan waktu ',waktu);
        postinganList(idGroup,dataGroup,dataPosting,waktu);    
        writeln('============================');
        readln();    
    end;
    procedure deletePostingan(idGroup:integer;dataUser:arrUser;dataGroup:arrGroup;var dataPosting:arrPosting);
    var
        j,idpost,i:integer;
        tempPost:arrPosting;
    begin
        i:= 1;
        j:= 1;
        clrscr;
        writeln('============================');    
        writeln('List Postingan ');
        postinganList(idGroup,dataGroup,dataPosting,'self');    
        writeln('============================');
        writeln('Masukan ID Postingan');
        readln(idpost);
        while(i <= dataPosting.N) do
        begin
            if(i <> idpost) then
            begin
                tempPost.data[j] := dataPosting.data[i];
                tempPost.data[j].idPosting := j;
                i:= i + 1;
                j:= j + 1;
            end
            else
                i:= i + 1;
        end;
        tempPost.N := dataPosting.N - 1;
        dataPosting := tempPost;
        writeln('Hapus Data Sukses , Tekan enter untuk melanjutkan');
        readln();    
    end;
    procedure lihatPostinganPencarian(idGroup:integer;dataUser:arrUser;dataGroup:arrGroup;dataPosting:arrPosting;param:string);
    var
        paramMain:string;
    begin
        clrscr;
        writeln('Masukan ',param,' :');
        readln(paramMain);
        clrscr;
        writeln('============================');    
        writeln('Postingan berdasarkan Pencarian ',param,' :',paramMain);
        cariPostingan(idGroup,dataGroup,dataPosting,param,paramMain);    
        writeln('============================');
        readln();    
    end;
    procedure buatPosting(s_idUser,idGroupselected:integer;dataUser:arrUser;dataGroup:arrGroup;var dataPosting:arrPosting);
    var
        namaGroup:string;
        indexpost:integer;
    begin
        namaGroup:= dataGroup.data[idGroupselected].namaGroup;
        indexpost := dataPosting.N + 1;       
        clrscr;
        writeln('=======================');
        writeln('=== Buat Posting di ',namaGroup,'  ===');
        writeln('Tema :');
        readln(dataPosting.data[indexpost].tema);
        writeln('Judul :');
        readln(dataPosting.data[indexpost].judul);
        writeln('Isi :');
        readln(dataPosting.data[indexpost].isi);
        dataPosting.data[indexpost].idPenulis := s_idUser;
        dataPosting.data[indexpost].idGroup := idGroupselected;
        dataPosting.data[indexpost].idPosting := indexpost;
        dataPosting.N := indexpost;
        clrscr;
        writeln('Data Berhasil Di input, Tekan Enter Untuk Melanjutkan');
        readln();
    end;
    procedure menuPosting(s_idUser,idGroupselected:integer;dataUser:arrUser;dataGroup:arrGroup;dataPosting:arrPosting);
    var
        namaGroup:string;
        jumlahMember:integer;
        status:boolean;
        decision:integer;
    begin
        namaGroup:= dataGroup.data[idGroupselected].namaGroup;
        jumlahMember := dataGroup.data[idGroupselected].jumlahMember;
        status := true;
        while status do
        begin            
            clrscr;
            writeln('=======================');
            writeln('=== Selamat Datang  ===');
            writeln('=== Di Menu Posting ===');
            writeln(namaGroup);
            writeln('Jumlah Member :',jumlahMember);
            writeln('=======================');
            writeln('Menu ');
            writeln('1.Buat Postingan');
            writeln('2.Lihat Postingan Terbaru');
            writeln('3.Lihat Postingan Terlama');
            writeln('4.Cari Postingan(berdasarkan email penulis)');
            writeln('5.Cari Postingan(berdasarkan tema)');
            writeln('6.hapus Postingan');
            writeln('7.kembali');
            writeln('Pilih Menu :');
            readln(decision);
            if(decision = 1) then
                buatPosting(s_idUser,s_idGroup,dataUser,dataGroup,dataPosting)
            else if(decision = 2) then
                lihatPostingan(s_idGroup,dataUser,dataGroup,dataPosting,'terbaru')
            else if(decision = 3) then
                lihatPostingan(s_idGroup,dataUser,dataGroup,dataPosting,'terlama')
            else if(decision = 4) then
                lihatPostinganPencarian(s_idGroup,dataUser,dataGroup,dataPosting,'email')
            else if(decision = 5) then
                lihatPostinganPencarian(s_idGroup,dataUser,dataGroup,dataPosting,'tema') 
            else if(decision = 6) then
                deletePostingan(s_idGroup,dataUser,dataGroup,dataPosting)   
            else if(decision = 7) then
                status := false
            else
                status := true;
        end;
    end;
    procedure inviteMember(idGroupselected:integer;var dataGroup:arrGroup);
    var
        email:string;
        id,idxMem:integer;
    begin
            clrscr;
            writeln('=======================');
            writeln('Invite Member Ke group ');
            writeln('=======================');
            writeln('Masukan email :');
            readln(email);        
            clrscr;
            if(not validationRegister(email))then
            begin
                id:= getIdByEmail(dataUser,email);
                idxMem := dataGroup.data[idGroupselected].jumlahMember +1;
                dataGroup.data[idGroupselected].memberList[idxMem].idUser := id;
                dataGroup.data[idGroupselected].jumlahMember := idxMem;
                writeln('Berhasil Mengundang user email',email,' ',id,' ',dataGroup.data[idGroupselected].jumlahMember);
            end
            else
                writeln('Gagal Mengundang user');
            readln();
    end;
    procedure menuMainGroup(s_idUser,idGroupselected:integer;dataUser:arrUser;var dataGroup:arrGroup;dataPosting:arrPosting);
    var
        namaGroup:string;
        jumlahMember:integer;
        status:boolean;
        decision:integer;
    begin
        namaGroup:= dataGroup.data[idGroupselected].namaGroup;
        status := true;
        s_idGroup := idGroupselected;
        while status do
        begin            
        jumlahMember := dataGroup.data[idGroupselected].jumlahMember;
            clrscr;
            writeln('=======================');
            writeln('=== Selamat Datang  ===');
            writeln(namaGroup);
            writeln('Jumlah Member :',jumlahMember);
            writeln('=======================');
            writeln('Menu ');
            writeln('1.Postingan');
            writeln('2.Undang Member');
            writeln('3.kembali');
            writeln('Pilih Menu :');
            readln(decision);
            if(decision = 1) then
                menuPosting(s_idUser,s_idGroup,dataUser,dataGroup,dataPosting)
            else if(decision = 2) then
                inviteMember(s_idGroup,dataGroup)
            else if(decision = 3) then
                status := false
            else
                status := true;
        end;
    end;
    procedure menuListMenuGroup(dataUser:arrUser;var dataGroup:arrGroup;dataPosting:arrPosting;param:string);
    var
        idGroupselected,indexGroup:integer;
        dataGroupSelected,kosong,dataGroupTemp:arrGroup;
    begin
        kosong.N := 0;
        status:= true;
        while status do
        begin
        if (param = 'jumlahmemberterendah') then
            begin
                cloneDataGoup(dataGroup,dataGroupTemp);
                sortingDataGroup(dataGroupTemp,param);
                dataGroupSelected := dataGroupTemp;
                writeln(dataGroupSelected.data[1].idGroup);
            end
        else if (param = 'jumlahmemberterbesar') then
            begin
                cloneDataGoup(dataGroup,dataGroupTemp);
                sortingDataGroup(dataGroupTemp,param);
                dataGroupSelected := dataGroupTemp;
                writeln(dataGroupSelected.data[1].idGroup);
            end
        else
            begin
                dataGroupSelected := dataGroup;
            end;

            idGroupselected:= -1;
            clrscr;
            writeln('======================================');
            writeln('=             Pilih Group            =');
            writeln('=   Nama | Kode Group |Jumlah Member =');
            listgroup(s_idUser,dataUser,dataGroupSelected);
            writeln('0. Keluar');
            writeln('======================================');  
            writeln('Masukan Kode group');    
            readln(idGroupselected);
            indexGroup := getindexGroup(idGroupselected,dataUser,dataGroup);
            if(pilihGroup(s_idUser,indexGroup,dataGroup)) then
                menuMainGroup(s_idUser,indexGroup,dataUser,dataGroup,dataPosting)
            else if (idGroupselected = 0) then
            begin
                status := false;
                dataGroupSelected := kosong;
                dataGroupTemp := kosong;
            end
            else
                status := true;
                
        end;

    end;
    procedure buatGroup(s_idUser:integer;dataUser:arrUser;var dataGroup:arrGroup);
    var
        indexGroup:integer;
    begin
        clrscr;
        indexGroup := dataGroup.N +1;
        writeln('==========================');
        writeln('=        Buat Group       ');
        writeln('==========================');
        writeln('Nama Group :');
        readln(dataGroup.data[indexGroup].namaGroup);
        dataGroup.data[indexGroup].idGroup := Random(999)+1000;
        dataGroup.data[indexGroup].jumlahMember := 1;
        dataGroup.data[indexGroup].memberList[1].idUser := s_idUser;
        dataGroup.N := indexGroup;
        clrscr;
        writeln('Buat Group Berhasil, Tekan Enter Untuk Melanjutkan');
        readln();
    end;
    procedure menuGroup(dataUser:arrUser;var dataGroup:arrGroup;dataPosting:arrPosting);
    var
        decision:char;
        status:boolean;
    begin
        status := true;
            while status do
            begin
                clrscr;
                writeln('====================================================');
                writeln('=               Pilih Group                        =');
                writeln('= 1.ListGroup                                      =');
                writeln('= 2.ListGroup(Berdasarkan Jumlah Member Terbesar ) =');
                writeln('= 3.ListGroup(Berdasarkan Jumlah Member Terkecil ) =');
                writeln('= 4.BuatGroup                                      =');
                writeln('= 5.Main Menu Awal                                 =');
                writeln('=                                                  =');
                writeln('====================================================');      
                readln(decision);  
                case decision of 
                '1' : menuListMenuGroup(dataUser,dataGroup,dataPosting,'default');
                '2' : menuListMenuGroup(dataUser,dataGroup,dataPosting,'jumlahmemberterbesar');
                '3' : menuListMenuGroup(dataUser,dataGroup,dataPosting,'jumlahmemberterendah');
                '4' : buatGroup(s_idUser,dataUser,dataGroup); 
                '5' : status := false;
            end;
        end;
    end;
    procedure editProfil(var dataUser:arrUser);
    begin
            clrscr;
            writeln('==================');
            writeln('=                =');
            writeln('Nama :',dataUser.data[s_idUser].nama);
            writeln('Email:',dataUser.data[s_idUser].email);
            writeln('No HP',dataUser.data[s_idUser].noHP);
            writeln('Regional',dataUser.data[s_idUser].regional);
            writeln('=                =');
            writeln('==================');      
            writeln('= Nama ');
            readln(dataUser.data[s_idUser].nama);
            writeln('= Email');
            readln(dataUser.data[s_idUser].email);
            writeln('= Password');
            readln(dataUser.data[s_idUser].password);
            writeln('= Nomor HP');
            readln(dataUser.data[s_idUser].noHP);
            writeln('= Regional');
            readln(dataUser.data[s_idUser].regional);
            writeln('==================');
            clrscr;          
            writeln('data berhasil diubah, press enter to continue...');    
            readln();      
    end;
    procedure profile(dataUser:arrUser);
    var
        decision:char;
        status:boolean;
    begin
        status:= true;
        while status do
        begin
            clrscr;
            writeln('==================');
            writeln('=                =');
            writeln('Nama :',dataUser.data[s_idUser].nama);
            writeln('Email:',dataUser.data[s_idUser].email);
            writeln('No HP',dataUser.data[s_idUser].noHP);
            writeln('Regional',dataUser.data[s_idUser].regional);
            writeln('=                =');
            writeln('==================');      
            writeln('= 1.Edit Profile =');
            writeln('=    2.Back      =');
            writeln('=                =');
            writeln('==================');      
            readln(decision);    
            case decision of 
            '1' : editProfil(dataUser);
            '2' : status := false;
        end;
    end;
    end;
    procedure ListUser(dataUsr:arrUser;param:string);
    var
        c,i,idx_min,pass:integer;
        temp:user;
        dataUser:arrUser;
    begin
        dataUser := dataUsr;
        pass:= 1;
        if(param = 'kecil') then
        begin
            while(pass <= dataUser.N - 1) do 
            begin
                idx_min := pass;
                i := idx_min + 1;
                while (i <= dataUser.N) do
                begin
                    if(dataUser.data[idx_min].noHP > dataUser.data[i].noHP ) then
                    begin
                        idx_min := i;
                    end;
                    i:= i + 1;
                end;
                temp:=dataUser.data[idx_min];
                dataUser.data[idx_min]:=dataUser.data[pass];
                dataUser.data[pass] := temp;
                pass := pass + 1;
            end;
        end
        else if (param = 'besar') then
        begin
            while(pass <= dataUser.N - 1) do 
            begin
                idx_min := pass;
                i := idx_min + 1;
                while (i <= dataUser.N) do
                begin
                    if(dataUser.data[idx_min].noHP < dataUser.data[i].noHP ) then
                    begin
                        idx_min := i;
                    end;
                    i:= i + 1;
                end;
                temp:=dataUser.data[idx_min];
                dataUser.data[idx_min]:=dataUser.data[pass];
                dataUser.data[pass] := temp;
                pass := pass + 1;
            end;            
        end;
        c := 1;
        clrscr; 
        writeln('=================================');
        writeln('Urutkan Berdasarkan No HP ',param);       
        writeln('=================================');
        while(c <= dataUser.N) do
        begin
            writeln('==================');
            writeln('=                =');
            writeln('Nama :',dataUser.data[c].nama);
            writeln('Email:',dataUser.data[c].email);
            writeln('No HP',dataUser.data[c].noHP);
            writeln('Regional',dataUser.data[c].regional);
            writeln('=                =');
            writeln('==================');
            
            c:= c + 1;
        end;
            writeln(dataUser.N);
            readln();
    end;
    procedure menuMain(dataUser:arrUser;dataGroup:arrGroup;dataPosting:arrPosting);
    var
        decision:char;
        status:boolean;
    begin
        status:= true;
        while status do
        begin
            clrscr;
            writeln('===========================================');
            writeln('=                                        =');
            writeln('=    1.Group                             =');
            writeln('=    2.Profile                           =');
            writeln('=    3.ListUser(NoHP Kecil - Besar)      =');
            writeln('=    4.ListUser(NoHP Besar - Kecil)      =');
            writeln('=    5.Logout                            =');
            writeln('=                                        =');
            writeln('==========================================');      
            readln(decision);    
            case decision of 
            '1' : menuGroup(dataUser,dataGroup,dataPosting);
            '2' : profile(dataUser);
            '3' : ListUser(dataUser,'kecil');
            '4' : ListUser(dataUser,'besar');
            '5' : status:=false;
        end;
    end;
    end;

    procedure login(dataUser:arrUser; dataGroup:arrGroup;dataPosting:arrPosting);
    var 
        email,password:string;
    begin
        clrscr;
        s_idUser:=0;
        writeln('==================');
        writeln('=                =');
        writeln('=                =');
        writeln('=      Login     =');
        writeln('=                =');
        writeln('=                =');
        writeln('==================');
        writeln('Email :');
        readln(email);
        writeln('password :');
        readln(password);
        if(loginBool(email,password) >= 1) then
        begin
            writeln('selamat datang ',email);
            writeln('Press enter to continue');
            readln();
            s_idUser:=loginBool(email,password);
            menuMain(dataUser,dataGroup,dataPosting);
        end
        else if (loginBool(email,password) = -1) then
        begin            
            writeln('user not found');
            readln();
        end
        else
            writeln('data cannot be empty');
            readln();
    end;

    procedure daftar(var dataUser:arrUser);
    var 
         email,password,nama,regional:string;
         noHP:string;
    begin
        clrscr;
        writeln('==================');
        writeln('=                =');
        writeln('=                =');
        writeln('=      Daftar    =');
        writeln('=                =');
        writeln('=                =');
        writeln('==================');
        writeln('Email :');
        readln(email);
        writeln('password :');
        readln(password);
        writeln('Nama');
        readln(nama);
        writeln('no hp');
        readln(noHP);
        writeln('regional');
        readln(regional);
        if(register(email,password,nama,regional,noHP)) then
            begin
            writeln('berhasil mendaftarkan user,silahkan login');
            writeln('Press enter to continue');
            readln();
            end
        else 
        begin
            writeln('gagal mendaftar ,user exist');
            writeln('Press enter to continue');
            readln();   
        end;     
    end;
procedure mainMenu(var stz:boolean);
var
    status:boolean;
begin
    status := true;
    while status do
    begin
        clrscr;
        writeln('==================');
        writeln('=                =');
        writeln('=    1.Login     =');
        writeln('=    2.Daftar    =');
        writeln('=                =');
        writeln('=                =');
        writeln('==================');      
        readln(decision);  
        case decision of 
        '1' : login(dataUser,dataGroup,dataPosting);
        '2' : daftar(dataUser);
        'x' : begin 
                status := false;
                stz := false;
            end;
        end;
    end;
end;
begin
    Randomize;
    dataUser.data[1].email := 'iqbalsyamilayas@gmail.com';
    dataUser.data[1].nama := 'iqbalsyamilayas';
    dataUser.data[1].password := '133245';
    dataUser.data[1].regional := 'bekasi';
    dataUser.data[1].noHP := '08788720945';
    dataUser.data[1].idUser := 1;

    dataUser.data[2].email := 'bramloko@gmail.com';
    dataUser.data[2].nama := 'mascuy12';
    dataUser.data[2].password := '133245';
    dataUser.data[2].regional := 'bekasi';
    dataUser.data[2].noHP := '08788720929';
    dataUser.data[2].idUser := 2;

    dataUser.data[3].email := 'ipat@gmail.com';
    dataUser.data[3].nama := 'ipat';
    dataUser.data[3].password := '133245';
    dataUser.data[3].regional := 'semarang';
    dataUser.data[3].noHP := '08788720988';
    dataUser.data[3].idUser := 3;

    dataUser.data[4].email := 'sansan@gmail.com';
    dataUser.data[4].nama := 'sansan';
    dataUser.data[4].password := '133245';
    dataUser.data[4].regional := 'jakarta';
    dataUser.data[4].noHP := '08788720923';
    dataUser.data[4].idUser := 4;

    dataUser.N := 4;

    dataGroup.data[1].idGroup := Random(999)+1000;;
    dataGroup.data[1].jumlahMember := 2;
    dataGroup.data[1].namaGroup := 'Sunmori';
    dataGroup.data[1].memberList[1].idUser := 1;
    dataGroup.data[1].memberList[2].idUser := 2;
    
    dataGroup.data[2].idGroup := Random(999)+1000;
    dataGroup.data[2].jumlahMember := 1;
    dataGroup.data[2].namaGroup := 'Komputer Indonesia';
    dataGroup.data[2].memberList[1].idUser := 1;

    dataGroup.data[3].idGroup := Random(999)+1000;;
    dataGroup.data[3].jumlahMember := 1;
    dataGroup.data[3].namaGroup := 'Memasak Indonesia';
    dataGroup.data[3].memberList[1].idUser := 1;
    
    dataGroup.data[4].idGroup := Random(999)+1000;
    dataGroup.data[4].jumlahMember := 1;
    dataGroup.data[4].namaGroup := 'adsadasdsadas';
    dataGroup.data[4].memberList[1].idUser := 1;

    dataGroup.N := 4;
    dataPosting.N := 0;
    status := true;
    while status do
    begin
        mainMenu(status);
    end;
end.