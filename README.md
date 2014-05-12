<h1>visualizeCampari</h1>

<h3>Overview</h3>
<p>
These scripts are designed to take in a directory where raw CAMPARI data was generated an then generate a basic presentation, to visualize the data.
</p>
<p>
It accomplishes this using Shell Scripting, Python, Matlab, and the OpenOffice API (UNO).
</p>

<h3>Usage</h3>
<p>
Simply running the shell script with the directory of your CAMPARI output will create the graphs and the presentation.
</p>

`./visualizeCampari.sh ../../../InterestingCampariRunDir/`

<p>
Inside the shell script, presentCampari.py can be manually altered in a couple ways. 
</p>

<ul>
<li>The 'directory' (-d) specifies the CAMPARI directory to be analyzed. It is the only required argument.</li>
<li>The 'title' (-t) is displayed on the first slide of the presentation.</li>
<li>The 'format' (-f) is a presentation format allowed by Open Office Impress (eg ppt, odp, odg, etc).</li>
<li>The 'output' (-o) is the name desired for the output presentation file.</li>
</ul>

`python presentCampari.py -d $ABSPATH -t aTitle -f aFormat -o anOutputFileName`


<h3>Next Steps</h3>
<p>
This project is far from complete, and there is a lot left to do. Some of the things planned include:
<ol>
<li>Finish graphing the possible output files from CAMPARI using the most generalized methods possible.</li>
<li>Add proper titles to the slides for each graphic in the presentation</li>
<li>Condense very similar graphs that relate to each other onto single slides</li>
<li>Create a method to allow people to have a key file specifying what parts of the CAMPARI data they want in their output presentation.</li>
</ol>
</p>
