@echo off

::
:: (c) Simone 2020
::

setlocal enabledelayedexpansion

:main
    title (c) Simone 2020
    
    echo.
    echo Scopre le parolechiave WiFi v1.0 (c) Simone 2020
    echo.
    echo Subscribe to my YouTube channel #SimoneDeLuca
    echo.
	echo https://www.youtube.com/channel/UCYiOoIHm9EzauoXAtHfx1mw/
	echo.
	echo.
    set KEYCONTENT=Key Content
    set ALL_PROFILES=All User Profile
    for /F "usebackq tokens=*" %%a IN (`wmic os get OSLanguage /Value`) DO (
        set _line=%%a
        if "!_line:~0,10!"=="OSLanguage" (
            set lang_id=!_line:~11!
        )
    )
    if "%lang_id%"=="1033" (
        echo English linguaggio del sistema operativo trovato!

    ) else if "%lang_id%" == "1034" (
        set KEYCONTENT=Contenido de la clave
        set ALL_PROFILES=Perfil de todos los usuarios
	    echo Spanish linguaggio del sistema operativo trovato!
    ) else if "%lang_id%" == "1036" (
        set KEYCONTENT=Contenu de la cl
        set ALL_PROFILES=Profil Tous les utilisateurs
        echo French linguaggio del sistema operativo trovato!
    ) else if "%lang_id%" == "1040" (
        set KEYCONTENT=Contenuto chiave
        set ALL_PROFILES=Tutti i profili utente
	    echo Italian linguaggio del sistema operativo trovato!
    ) else if "%lang_id%" == "1031" (
        set KEYCONTENT=Schlüsselinhalt
        set ALL_PROFILES=Profil für alle Benutzer
        echo Deutsches OS erkannt!
    ) else (
        echo Warning: Linguaggio ignoto del sistema operativo trovato! Lo script potrebbe non funzionare.
    )

    echo.
    call :get-profiles r
    :main-next-profile
        for /f "tokens=1* delims=," %%a in ("%r%") do (
            call :get-key "%%a" key
            if "!key!" NEQ "" (
                echo WiFi: {%%a} Password: {!key!}
            )
            set r=%%b
        )
        if "%r%" NEQ "" goto main-next-profile

    echo.
    pause

    goto :eof
:get-key <1=profile-name> <2=out-profile-key>
    setlocal

    set result=

    FOR /F "usebackq tokens=2 delims=:" %%a in (
        `netsh wlan show profile name^="%~1" key^=clear ^| findstr /C:"%KEYCONTENT%"`) DO (
        set result=%%a
        set result=!result:~1!
    )
    (
        endlocal
        set %2=%result%
    )

    goto :eof
:get-profiles <1=result-variable>
    setlocal
    set result=  
    FOR /F "usebackq tokens=2 delims=:" %%a in (
        `netsh wlan show profiles ^| findstr /C:"%ALL_PROFILES%"`) DO (
        set val=%%a
        set val=!val:~1!

        set result=%!val!,!result!
    )
    (
        endlocal
        set %1=%result:~0,-1%
    )

    goto :eof