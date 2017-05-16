

import java.io.IOException;
import java.util.*;
import java.util.concurrent.atomic.AtomicInteger;

import javax.xml.parsers.ParserConfigurationException;
import javax.xml.parsers.SAXParser;
import javax.xml.parsers.SAXParserFactory;

import org.xml.sax.Attributes;
import org.xml.sax.SAXException;
import org.xml.sax.helpers.DefaultHandler;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.*;
import java.util.*;
import java.text.*;


public class ParseAll{

    public static void main(String[] args) {
        ParseMain pm = new ParseMain(args[0]);
        pm.startParsing();

        ParseActor pa = new ParseActor(args[1]);
        pa.startParsing();

        LinkedHashMap<String,Movie> movieMap = pm.movieMap;
        LinkedHashMap<String,Genre> genreMap = pm.genreMap;
        ArrayList<Genres_in_movies> gm_relation = pm.gm_relation;
        LinkedHashMap<String,Star> starMap = pa.starMap;

        ParseCast pc = new ParseCast(args[2], starMap, movieMap);
        pc.startParsing();

        ArrayList<Stars_in_movies> sm_relation = pc.sm_relation;1

    }

    public ParseAll(){

    }

    public void addToDB(){
        try {
            Connection conn = null;
            Class.forName("com.mysql.jdbc.Driver").newInstance();
            String jdbcURL="jdbc:mysql://localhost:3306/moviedb";
            conn = DriverManager.getConnection(jdbcURL,"root", "cs122b");
            


            if(conn!=null) conn.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void addMovies(Connection conn, LinkedHashMap<String,Movie> movieMap) throws Exception{
        PreparedStatement psInsertRecord=null;
        String sqlInsertRecord=null;
        int[] iNoRows=null;
        sqlInsertRecord="insert into movies (title, year, director) values(?,?,?)";
        conn.setAutoCommit(false);

        psInsertRecord=conn.prepareStatement(sqlInsertRecord);


        for (Map.Entry<String, Movie> entry : movieMap.entrySet()) {
            Movie movie = entry.getValue();
            psInsertRecord.setString(1,movie.getTitle());
            psInsertRecord.setInt(2,movie);

            psInsertRecord.addBatch();
        }

        for(int i=1;i<=50;i++)
        {
            
            
        }

        iNoRows=psInsertRecord.executeBatch();
        conn.commit();
        if(psInsertRecord!=null) psInsertRecord.close();
    }

}


class ParseCast extends DefaultHandler{

    public ArrayList<Stars_in_movies> sm_relation = null;
    private LinkedHashMap<String,Star> starMap = null;
    private LinkedHashMap<String,Movie> movieMap = null;

    private Movie currMovie = null;
    private Star currStar = null;
    private Stars_in_movies currRelation = null;

    private String filename;
    private String tempVal;

    public ParseCast(String mainxml, LinkedHashMap<String,Star> starMap, LinkedHashMap<String,Movie> movieMap )
    {
        this.starMap = starMap;
        this.movieMap = movieMap;
        filename = mainxml;
        sm_relation = new ArrayList<>();
    }

    private void printAll(){
        int counter = 0;
        for (Stars_in_movies sm : sm_relation) {
            System.out.println(sm);
            counter++;
        }
        System.out.println(counter);
    }

    public void startParsing(){
        SAXParserFactory spf = SAXParserFactory.newInstance();
        try{
            SAXParser sp = spf.newSAXParser();
            sp.parse(filename,this);

            //printAll();
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
        if(qName.equalsIgnoreCase("m")){
            currRelation = new Stars_in_movies(); 
        }
    }

    public void characters(char[] ch, int start, int length) throws SAXException {
        tempVal = new String(ch,start,length);
    }

    public void endElement(String uri, String localName, String qName) throws SAXException {
        if(qName.equalsIgnoreCase("f")) {
            if (movieMap.get(tempVal)  != null) {
                currMovie = movieMap.get(tempVal);
            }
        }else if(qName.equalsIgnoreCase("a")){
            if (starMap.get(tempVal)  != null) {
                currStar = starMap.get(tempVal);
            }
        }else if(qName.equalsIgnoreCase("m")){
            if (currStar != null && currMovie != null) {
                currRelation.setStarID(currStar.qid);
                currRelation.setMovieID(currMovie.qid);
                sm_relation.add(currRelation);
            }
            currStar = null;
            currMovie = null;
        }
    }
}

class ParseActor extends DefaultHandler{

    public LinkedHashMap<String,Star> starMap = null;

    private String filename = null;

    private String tempVal = null;

    private String currStageName = null;

    private Star currStar = null;


    public ParseActor(String mainxml){
        filename = mainxml;
        starMap = new LinkedHashMap<>();
    }

    private void printAll(){
        int counter = 0;
        for (Map.Entry<String, Star> entry : starMap.entrySet()) {
            String key = entry.getKey();
            Star value = entry.getValue();
            System.out.println(key + " "+value);
            counter++;
        }
        System.out.println(counter);
    }

    public void startParsing(){
        SAXParserFactory spf = SAXParserFactory.newInstance();
        try{
            SAXParser sp = spf.newSAXParser();
            sp.parse(filename,this);

            //printAll();
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
        if(qName.equalsIgnoreCase("actor")){
            currStar = new Star(); 
        }
    }

    public void characters(char[] ch, int start, int length) throws SAXException {
        tempVal = new String(ch,start,length);
    }

    public void endElement(String uri, String localName, String qName) throws SAXException {
        if(qName.equalsIgnoreCase("actor")) {
            if (currStar.getFirst_name().isEmpty() && currStar.getLast_name().isEmpty()){
                currStar = null;
                return;
            }
            if (starMap.get(tempVal) == null) {
                currStar.setQID();
                starMap.put(currStageName,currStar);
            }

        }else if(qName.equalsIgnoreCase("stagename")){
            currStageName = tempVal;
            String[] names = tempVal.trim().split(" ",2);
            if (names.length < 2) {
                currStar.setLast_name(names[0]);
            }else{
                currStar.setFirst_name(names[0]);
                currStar.setLast_name(names[1]);
            }
            
        }else if(qName.equalsIgnoreCase("dob")){
            currStar.setDob(tempVal+"/01/01");
        }
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
        int counter = 0;
        // for (Map.Entry<String, Movie> entry : movieMap.entrySet()) {
        //     String key = entry.getKey();
        //     Movie value = entry.getValue();
        //     System.out.println(key + " "+value);
        //     counter++;
        // }
        // System.out.println(counter);
        
        // for (Map.Entry<String, Genre> entry : genreMap.entrySet()) {
        //     String key = entry.getKey();
        //     Genre value = entry.getValue();
        //     System.out.println(key + " "+value);
        //     counter++;
        // }
        // System.out.println(counter);

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
        }
    }

    public void characters(char[] ch, int start, int length) throws SAXException {
        tempVal = new String(ch,start,length);
    }

    public void endElement(String uri, String localName, String qName) throws SAXException {
        if(qName.equalsIgnoreCase("film")) {
            if (movieMap.get(currMovie.getID()) == null) {
                currMovie.setQID();
                movieMap.put(currMovie.getID(),currMovie);
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

        }else if(qName.equalsIgnoreCase("dirid")){
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
    private String banner_url ="";
    private String trailer_url = "";

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
    private String first_name = "";
    private String last_name = "";
    private String dob = "";
    private String photo_url = "";

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

    public String getDob(){
        return dob;
    }

    public void setDob(String dob){
        this.dob=dob;
    }

    public String getPhoto_url(){
        return photo_url;
    }

    public void setPhoto_url(String photo_url){
        this.photo_url=photo_url;
    }
    @Override
    public String toString(){
        return "Star ID: " + qid + " Name: " + first_name + " " + last_name + " DOB: "+ dob;
    }
    @Override
    public int hashCode() {
        return Objects.hash(first_name,last_name);
    }
}


class Stars_in_movies{
    private int star_id;
    private int movie_id;

    public Stars_in_movies(){

    }

    public int getStarID(){
        return star_id;
    }

    public void setStarID(int id){
        this.star_id = id;
    }

    public int getMovieID(){
        return movie_id;
    }

    public void setMovieID(int id){
        this.movie_id=id;
    }

    @Override
    public String toString(){
        return "Starid " + star_id + " MovieID " + movie_id;
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




