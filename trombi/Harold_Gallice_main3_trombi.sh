#!/bin/bash

#ligne pour decompresser notre archive
tar xvzf $1

#recuperation de la liste des jpg 
liste_jpg=`ls *.jpg`
#pour decouper une ligne on va utiliser la commande cut
#pensons a cmd <<< chaine pour pouvoir utiliser cut sur une variable

#creation fichier filieres.txt
touch filieres.txt
#Pour chaque image on cree un repertoire (si il n'existe pas) et on y ajoute l'image
for image in $liste_jpg
do
    name=`echo $image | cut -d_ -f2`
    name=$name.`echo $image | cut -d_ -f1`.jpg #creation nom de l'image
    spe=`echo $image | cut -d_ -f3`
    spe=$spe`echo $image | cut -d_ -f4 | cut -d. -f1` #creation nom du repertoire
    mkdir -p $spe #creation repertoire
    convert -resize 90x120 $image $spe/$name
    rm $image
    if [ -z `grep $spe filieres.txt` ]; #on verifie que cette filiere n'est pas presente dans le fichier txt
    then echo ""$spe"" >> filieres.txt; #on l'ajoute
    else : ; #on ne fait rien (deja presente)
    fi    
done

#creation des fichiers html
while read line; do
    file=$line/index.html
    touch $file
    echo "<html><head><title> Trombinoscope Spé $line</title></head>
<body>
<h1 align='center'>Trombinoscope Spé $line</h1>
<table cols=2 align='center'>
<tr>" > $file
    liste_image=`ls $line/*.jpg`
    for image in $liste_image; do
	image=`basename $image`
	nom=`echo $image | cut -d. -f2`
	nom="$nom `echo $image | cut -d. -f1`"
	echo "<td><img src=""$image"" width=90 height=120/><br/>"$nom"</td>" >> $file
    done
    echo "</tr>
</table>
</body></html>" >> $file
    
done < filieres.txt 
