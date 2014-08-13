MISA: Minimally Improved Segmental Alignment
============================================

An MATLAB algorithm for selection of segments for subsequent icoshift-based alignment.

## Background 

[Icoshift](http://www.models.life.ku.dk/icoshift) is an incredibly effective tool for the
correlation alignment of spectra. In common use spectra are segmented and correlation
alignment is performed across these segments in turn. The result is a nicely aligned 
entire spectrum.

Unfortunately there is no good algorithm for selecting the segments on the spectra. The
standard (and what we presently use) is to use a set number (e.g. 50) of equally spaced 
segments for an normal NMR metabolomics spectra. This produces can produce very good results,
but it has a number of issues:

- Segment edges that land on a peak/cluster will prevent that peak, and sometimes the 
entire segment from being aligned
- Segments that incorporate two differentially shifted peaks (one left, one right) will 
prevent alignment of the segment

This algorithm is an attempt to reduce the occurrence of the first issue through a simple 
minima search around the default segment edges. Provided with a standard number of 
segments (e.g. 50) it iteratively shifts the right hand edge of the segment to the lowest 
point +/- 1/2 the segment edge.

The result is more segments (maximum +50%; usually less) but that are better arranged to miss
the peaks in the spectra. The tendency towards smaller bins also helps to reduce the impact
of the second issue above, but cannot eliminate it entirely.

## Use

To use call `misa` with a spectra, a number of segments and optionally an axis scale. If 
an axis scale is provided plots will be generated showing the default and optimised 
segmental shift.

    misa(spectra, 50);

    misa(spectra, 50, ppm);

The searching algorithm is available independently as `misa_find_segments`

    misa_find_segments(spectra, 50);
    
## Feedback

Comments, suggestions and feedback most welcome via Issues/Pull requests.

