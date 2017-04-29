import xml.etree.ElementTree as ET
import sys
import os
import itertools
from lxml import etree
import codecs
import re

class Anime:
    counter = 1
    def __init__(self):
        self.id = Anime.counter
        self.title = ''
        self.ja_title = ''
        self.director = ''
        self.year = 0
        self.rating = 0.0
        self.picture_url = ''
        self.description = ''
        Anime.counter += 1
    def __str__(self):
        result =  'INSERT INTO animes VALUES('+str(self.id)+',\''+\
        re.escape(self.title)+'\',\''+re.escape(self.ja_title)+'\',\''+re.escape(self.director)+'\','+\
        str(self.year)+','+str(self.rating)+',\''+\
        self.picture_url+'\',\''+re.escape(self.description).replace("\n", "\\n")+ '\');'
        return result

class Voice_Actor:
    counter = 1
    def __init__(self):
        self.id = Voice_Actor.counter
        self.first_name = ''
        self.last_name = ''
        self.picture_url = ''
        Voice_Actor.counter += 1
    def __str__(self):
        result =  'INSERT INTO voice_actors VALUES ('+str(self.id)+',\''+\
        re.escape(self.first_name)+'\',\''+re.escape(self.last_name)+'\',\''+self.picture_url+'\');'
        return result

class Genre:
    counter = 1
    def __init__(self):
        self.id = Genre.counter
        self.name = ''
        Genre.counter += 1
    def __str__(self):
        result =  'INSERT INTO genres VALUES ('+str(self.id)+',\''+self.name+'\');'
        return result


class Genre_Anime:
    def __init__(self):
        self.anime_id = 0
        self.genre_id = 0
        
    def __str__(self):
        result =  'INSERT INTO genres_in_animes VALUES ('+str(self.anime_id)+','+str(self.genre_id)+');'
        return result

class VA_Anime:
    def __init__(self):
        self.anime_id = 0
        self.va_id = 0
    def __str__(self):
        result =  'INSERT INTO voice_actors_in_animes VALUES ('+str(self.anime_id)+','+str(self.va_id)+');'
        return result
img_path = 'http://img7.anidb.net/pics/anime/'
def main():
    animes = []
    genres = []
    voice_actors = []
    relation_genre_anime = []
    relation_va_anime = []
    for root, dirs, files in os.walk('xmls/', topdown=False):
        for filename in files:
            document = etree.parse('xmls/'+filename)
            root = document.getroot()
            ani = Anime()
            animes.append(ani)
            for title in document.xpath('//titles[1]/title'):
                if('en' in title.xpath("./@xml:lang")):
                    ani.title = title.text
                elif('x-jat' in title.xpath("./@xml:lang")):
                    ani.title = title.text
                if('ja' in title.xpath('./@xml:lang')):
                    ani.ja_title = title.text
            for date in document.xpath('//startdate'):
                ani.year = int(date.text.split('-')[0])
            for creator in document.xpath('//creators/name'):
                if ('Direction' in creator.xpath("./@type")):
                    ani.director = creator.text
            ani.description = document.xpath('//description[1]')[0].text
            ani.rating = float(document.xpath('//ratings/permanent')[0].text)
            ani.picture_url = img_path+document.xpath('//picture[1]')[0].text
            for tag in document.xpath('//tags/tag/name'):
                ge = None
                genrelist = [x for x in genres if x.name == tag.text]
                if len(genrelist) > 0 :
                    ge = genrelist[0]
                else:
                    ge = Genre()
                    ge.name = tag.text
                    genres.append(ge)
                rega = Genre_Anime()
                rega.genre_id = ge.id
                rega.anime_id = ani.id
                relation_genre_anime.append(rega)
            for char in document.xpath('//characters/character/seiyuu'):
                va = None
                cnames = char.text.split(' ')
                cfname = cnames[0] if len(cnames) > 0 else ''
                clname = cnames[1] if len(cnames) > 1 else ''
                for x in voice_actors:
                    if x.first_name == cfname and x.last_name == clname:
                        va = x
                        break
                if va==None:
                    va = Voice_Actor()
                    names = char.text.split(' ')
                    if(len(names) < 2):
                        print(ani.id,char.text)
                    va.first_name = names[0] if len(names) > 0 else ''
                    va.last_name = names[1] if len(names) > 1 else ''
                    urls = char.xpath('./@picture')
                    va.picture_url = img_path+urls[0] if len(urls) > 0 else ''
                    voice_actors.append(va)
                reva = VA_Anime()
                reva.va_id = va.id
                reva.anime_id = ani.id
                relation_va_anime.append(reva)
    with codecs.open("data.sql","w","utf-8") as f:
        for a in animes:
            f.write(str(a))
            f.write('\n')
        for g in genres:
            f.write(str(g))
            f.write('\n')
        for va in voice_actors:
            f.write(str(va))
            f.write('\n')
        for rga in relation_genre_anime:
            f.write(str(rga))
            f.write('\n')
        for rva in relation_va_anime:
            f.write(str(rva))
            f.write('\n')
        with open("customers.sql","r") as cf:
            lines = cf.readlines()
            for line in lines:
                f.write(line)

main()