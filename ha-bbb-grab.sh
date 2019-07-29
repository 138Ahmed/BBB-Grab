#!/bin/sh

BASE="https://mercia.quickbase.com/db/"
AUTHENTICATE="&username=graham.davies@mercia.co.uk&password=tinyBab00nlet!"
FilePE='2019-07-31'
PE="20190731"
NPIF="NPIF"
MEIF="MEIF"
timestamp=$(date +%s)
for i in 'NPIF' 'MEIF'
do
    if [ $i = $NPIF ]
    then
        mkdir -p ~/BBB/NPIF\ Equity/Reporting/QB\ Data\ Upload/$FilePE/
        cd ~/BBB/NPIF\ Equity/Reporting/QB\ Data\ Upload/$FilePE/
        LPATH=`pwd`
        OUTFILE="$i - EVGROUP - $PE - Investment.csv"
        FILE="${LPATH}/${OUTFILE}"
        echo "Check -$FILE-"
        if [ -f "$FILE" ]; then                                       
            mv -f "${LPATH}/${OUTFILE}" "${LPATH}/${OUTFILE}.$timestamp"
        fi
        wget "${BASE}bmhks9ecr?act=API_GenResultsTable&options=csv&qid=5${AUTHENTICATE}" -O "$OUTFILE"
        sed -i -E 's,([0-9]{4})-([0-9]{2})-([0-9]{2}),\3/\2/\1,g' "${OUTFILE}"
        gpd-bbb-control.py > NPIF-ERRORS.txt
    elif [ $i = $MEIF ]
    then
        mkdir -p ~/BBB/MEIF\ ESPOC/Reporting/QB\ Data\ Upload/$FilePE/
        cd ~/BBB/MEIF\ ESPOC/Reporting/QB\ Data\ Upload/$FilePE/
        LPATH=`pwd`
        OUTFILE="$i - EVGROUP - $PE - Investment.csv"
        FILE="${LPATH}/${OUTFILE}"
        echo "Check -$FILE-"
        if [ -f "$FILE" ]; then
            mv -f "${LPATH}/${OUTFILE}" "${LPATH}/${OUTFILE}.$timestamp"
        fi
        wget "${BASE}bmhks9ecr?act=API_GenResultsTable&options=csv&qid=55${AUTHENTICATE}" -O "$OUTFILE"
        sed -i -E 's,([0-9]{4})-([0-9]{2})-([0-9]{2}),\3/\2/\1,g' "${OUTFILE}"
        gpd-bbb-control.py > MEIF-ERRORS.txt
    fi
done
