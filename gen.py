

def main():
    def char_range(c1, c2):
        """Generates the characters from `c1` to `c2`, inclusive."""
        """Using range instead of xrange as xrange is deprecated in Python3""" 
        for c in range(ord(c1), ord(c2)+1):
            yield chr(c)

    li = ["classic", "advanture", "kid", "musial", "arts", "SCI/FI", "Commedy", "Coming-of-Age-Drama", "Detective", "Gangster", "Love", "Suspense", "Indie", "epics", "spy", "JamesBond", "Roman", "Epics/Historial", "Tragedy", "SciFi", "Animation", "Film-Noir", "Musical", "Mystery", "Short", "Western", "ScienceFiction/Fantasy", "Documentary", "Musical/PerformingArts", "Crime", "Music", "Crime/Gangster", "Epics/Historical", "Musicals", "ScienceFiction", "War", "Westerns", "Family", "Action", "Adventure", "Drama", "Comedy", "Horror", "Thriller", "Foreign", "Sci-Fi", "Romance", "Fantasy"];

    for i in li:
        print("<li class=''><a href='/fabflix/jsp/Movie.jsp?genre="+i+"'>"+i+"</a></li>");



if __name__ == '__main__':
    main()