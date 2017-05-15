

import java.io.IOException;
import java.util.*;
import java.util.concurrent.atomic.AtomicInteger;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;


public class ParseAll{

    public static void main(String[] args) {
        new ParseMain(args[0]).startParsing();
    }
}

class ParseMain extends DefaultHandler{

	public LinkedHashMap<String,Movie> movieMap = null;
    public LinkedHashMap<String,Genre> genreMap = null;
    public ArrayList<Genres_in_movies> gm_relation = null;

    private String filename = null;

    private String tempVal = null;

    private Movie currMovie = null;
    private Genre currGenre = null;

    private String currDirectorID = null;
    private String currDirectorName = null;

    

    public ParseMain(String mainxml){
        filename = mainxml;
        movieMap = new LinkedHashMap<>();
        genreMap = new LinkedHashMap<>();
        gm_relation = new ArrayList<>();
    }

    private void printAll(){
        for (Map.Entry<String, Movie> entry : movieMap.entrySet()) {
            String key = entry.getKey();
            Movie value = entry.getValue();
            System.out.println(key + " "+value);
        }
        int counter = 0;
        for (Map.Entry<String, Genre> entry : genreMap.entrySet()) {
            String key = entry.getKey();
            Genre value = entry.getValue();
            System.out.println(key + " "+value);
            counter++;
        }
        System.out.println(counter);

        // for(ListIterator it = gm_relation.listIterator();it.hasNext();){
        //     System.out.println((Genres_in_movies)it.next());
        // }
    }

    public void startParsing(){
        SAXParserFactory spf = SAXParserFactory.newInstance();
        try{
            SAXParser sp = spf.newSAXParser();
            sp.parse(filename,this);

            printAll();
            

        }catch(SAXException se) {
			se.printStackTrace();
		}catch(ParserConfigurationException pce) {
			pce.printStackTrace();
		}catch (IOException ie) {
			ie.printStackTrace();
		}catch(Exception e){
            e.printStackTrace();
        }
    }

    public void startElement(String uri, String localName, String qName, Attributes attributes) throws SAXException {
        //reset
        tempVal = "";
        if(qName.equalsIgnoreCase("film")){
            currMovie = new Movie();
            currMovie.setDirector(currDirectorName);
        }else if(qName.equalsIgnoreCase("cat")){
            currGenre = new Genre();
        }else if(qName.equalsIgnoreCase("")){

        }
    }

    public void characters(char[] ch, int start, int length) throws SAXException {
        tempVal = new String(ch,start,length);
    }

    public void endElement(String uri, String localName, String qName) throws SAXException {
        if (tempVal.trim().equals("")) {
            return;
        }
        if(qName.equalsIgnoreCase("film")) {
            if (movieMap.get(currMovie.getID()) == null) {
                currMovie.setQID();
                movieMap.put(currMovie.getID(),currMovie);
            }else{
                currMovie = movieMap.get(currMovie.getID());
            }
            currMovie = null;

        }else if(qName.equalsIgnoreCase("cat")){

            if(genreMap.get(tempVal) == null){
                currGenre.setName(tempVal);
                currGenre.setQID();
                genreMap.put(tempVal,currGenre);
            }else{
                currGenre = genreMap.get(tempVal);
            }
            if (currMovie != null) {
                gm_relation.add(new Genres_in_movies(currGenre.qid, currMovie.qid));
            }

        }if(qName.equalsIgnoreCase("dirname")){
            currDirectorName = tempVal;
        }else if(qName.equalsIgnoreCase("fid")){
            currMovie.setID(tempVal);
        }else if(qName.equalsIgnoreCase("t")){
            currMovie.setTitle(tempVal);
        }else if(qName.equalsIgnoreCase("year")){
            currMovie.setYear(tempVal);
        }
    }
	
}


class Movie{
    private static final AtomicInteger count = new AtomicInteger(0);
    private String id;
    public int qid = -1;
    private String title;
    private String director;
    private String year;
    private String banner_url;
    private String trailer_url;

    public Movie(){

    }

    public void setQID(){
        qid = count.incrementAndGet();
    }

    public String getID(){
        return id;
    }

    public void setID(String id){
        this.id = id;
    }
    public String getTitle(){
        return title;
    }

    public void setTitle(String title){
        this.title=title;
    }

    public String getDirector(){
        return director;
    }

    public void setDirector(String director){
        this.director=director;
    }

    public String getYear(){
        return year;
    }

    public void setYear(String year){
        this.year=year;
    }

    public String getBanner_url(){
        return banner_url;
    }

    public void setBanner_url(String banner_url){
        this.banner_url=banner_url;
    }

    public String getTrailer_url(){
        return trailer_url;
    }

    public void setTrailer_url(String trailer_url){
        this.trailer_url=trailer_url;
    }
    @Override
    public String toString(){
        return "Movie ID: " + qid + " Title: " + title + " Year: " + year + " Director " + director;
    }
}


class Star{
    private static final AtomicInteger count = new AtomicInteger(0);
    private String id;
    public int qid = -1;
    private String first_name;
    private String last_name;
    private java.util.Date dob;
    private String photo_url;
    private String name;

    public Star(){

    }

    public void setQID(){
        qid = count.incrementAndGet();
    }

    public String getID(){
        return id;
    }

    public void setID(String id){
        this.id = id;
    }

    public String getFirst_name(){
        return first_name;
    }

    public void setFirst_name(String first_name){
        this.first_name=first_name;
    }

    public String getLast_name(){
        return last_name;
    }

    public void setLast_name(String last_name){
        this.last_name=last_name;
    }

    public java.util.Date getDob(){
        return dob;
    }

    public void setDob(java.util.Date dob){
        this.dob=dob;
    }

    public String getPhoto_url(){
        return photo_url;
    }

    public void setPhoto_url(String photo_url){
        this.photo_url=photo_url;
    }

    public String getName(){
        return name;
    }

    public void setName(String name){
        this.name=name;
    }
    @Override
    public String toString(){
        return "Star ID: " + qid + " Name: " + first_name + " " + last_name + " DOB: "+ dob.toString();
    }
}


class Stars_in_movies{
    private String star_id;
    private String movie_id;

    public Stars_in_movies(){

    }

    public String getStarID(){
        return star_id;
    }

    public void setStarID(String id){
        this.star_id = id;
    }

    public String getMovieID(){
        return movie_id;
    }

    public void setMovieID(String id){
        this.movie_id=id;
    }
}


class Genre{
    private static final AtomicInteger count = new AtomicInteger(0);
    public int qid = -1;
    private String name;

    public Genre(){

    }

    public void setQID(){
        qid = count.incrementAndGet();
    }

    public String getName(){
        return name;
    }

    public void setName(String name){
        this.name=name;
    }
    @Override
    public String toString(){
        return "Genre "+ qid+ " " + name;
    }
}

class Genres_in_movies{

    private int genre_id;
    private int movie_id;

    public Genres_in_movies(int genre_id, int movie_id){
        this.genre_id = genre_id;
        this.movie_id = movie_id;
    }

    public int getGenreID(){
        return genre_id;
    }

    public void setGenreID(int id){
        this.genre_id = id;
    }

    public int getMovieID(){
        return movie_id;
    }

    public void setMovieID(int id){
        this.movie_id=id;
    }
    @Override
    public String toString(){
        return " G_in_M "+ genre_id + " "+ movie_id;
    }
}




