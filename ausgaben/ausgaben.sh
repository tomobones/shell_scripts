#!/bin/bash


# todo
# - monats details - danach zusammenfassungen einz monate von diesem jahr - dann jahre
# - liste: betrag rechtsbündig
# - ausgaben seit neuem monat
# - mc ausgaben seit letzter rechnung
# - monatsauflistung nach genre
# - anteile der genre an gesamtausgaben
# - laufende ausgaben mit xxxx-xx-25 oder sowas

file="Library/Mobile Documents/27N4MQEA55~pro~writer/Documents/ausgaben.csv"

sum()
{
    if [ -z $1 ]
    then
        parameter=" "
    else
        parameter="$1"
    fi
    cat "$HOME"/"$file" |\
        grep "$parameter" |\
        cut -d';' -f 3 |\
        grep -v Betrag |\
        tr , . |\
        paste -sd+ - > tmp.txt

    test -s tmp.txt \
        && cat "tmp.txt" | bc | sed 's/\./,/g' \
        || echo "0,00"
    rm tmp.txt
}

liste()
{
    cat "$HOME"/"$file" |\
        #grep '#essen' |\
        cut -d ';' -f 1,3,4,5 |\
        tr -d '-' |\
        sed $'s/Betrag/\tBetrag/' |\
        tr ';' '\t'
}

if [ -r "$HOME"/"$file" ]
then
    printf "\nListe einzelner Ausgaben:\n";liste;printf "\n"
    printf "Summe aller Ausgaben: ";sum
    printf "Davon mit Mastercard: ";sum "mc"
    printf "Davon mit SK RNN:     ";sum "srnn"
    printf "Davon mit SK München: ";sum "sskm";printf "\n"
    printf "Essen: .............. ";sum "#essen"
    printf "Reisen: ............. ";sum "#reise"
    printf "Bewegung: ........... ";sum "#bewegung";printf "\n"

else
    echo "file not found"
fi

