% cSpell:disable
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{resume}[2025/09/05 Resume LaTeX class]

% kvoptions
\RequirePackage{kvoptions}

\SetupKeyvalOptions{
    family=resume,
    prefix=res@
}

\DeclareVoidOption{english}{\def\res@mainlang{english}}
\DeclareVoidOption{danish}{\def\res@mainlang{danish}}
\providecommand\res@mainlang{english}

\DeclareStringOption[2cm]{top}
\DeclareStringOption[2cm]{bottom}

\ProcessKeyvalOptions*

% Packages
\LoadClass[10pt]{article}

\RequirePackage[main=\res@mainlang, english, danish]{babel}
\RequirePackage[dvipsnames]{xcolor}
\RequirePackage{geometry, changepage, fontspec, microtype, enumitem, fancyhdr, tabularx, fontawesome5, environ, hyperref}

% Font
\defaultfontfeatures{Ligatures=TeX, Scale=MatchLowercase}
\setmainfont{TeX Gyre Pagella}
\setsansfont{TeX Gyre Heros}
\setmonofont{Fira Mono}

% Geometry
\geometry{
    a4paper,
    nomarginpar,
    includehead,
    includefoot,
    headheight=2.3cm,
    footskip=0.5cm,
    headsep=0.2cm,
    top=\res@top,
    bottom=\res@bottom,
    left=2cm,
    right=2cm,
    % showframe
}

% Hyperref
\hypersetup{
    colorlinks=true,
    linkcolor=DarkRed,
    urlcolor=RoyalBlue,
    pdfborder={0 0 0}
}

% Remove spacing before and after itemize
\setlist{nosep, before=\raggedright, after=\relax, itemsep=1pt}

% Header and Footer
\pagestyle{fancy}
\fancyhf{}
\renewcommand{\headrulewidth}{0pt} % Remove header divider line
\fancyfoot[C]{\thepage} % Add page number

% Print comma-separated list as dot-separated list
\ExplSyntaxOn
\seq_new:N \l_resume_tmpa_seq
\NewDocumentCommand\printdotlist{m}
{
    \seq_set_split:Nnn \l_resume_tmpa_seq {,} { #1 }
    \seq_use:Nn \l_resume_tmpa_seq {~\textperiodcentered{}~}
}
\ExplSyntaxOff

% Horizontal line under section headers
\newcommand\lineunder{\vspace*{-0.6\baselineskip}\noindent\hrulefill\par}

% Header
\NewDocumentCommand\header{m m m}{
    \fancyhead[C]{%
        {\LARGE\scshape #1\par}%
            {\Large \printdotlist{#2}\par\addvspace{0.4\baselineskip}}%
        \printdotlist{#3}%
    }
}

% Section header
\NewDocumentCommand\sectionheader{m}{
    \addvspace{0.5\baselineskip}%
    {\large\textsc{#1}}\par\lineunder
}

% Section content wrapper
\NewEnviron{sectioncontent}[1]{%
    \raggedright\sectionheader{#1}%
    \begin{adjustwidth}{1.5em}{0pt}%
        \BODY
    \end{adjustwidth}
}

% Section content with title, city, details, and from and to dates
\NewDocumentCommand\sectionwithdetails{O{} m m m m}{
    \textbf{#2}\hfill #3\par
    #1\hfill #4\textendash{}#5\par
}

% Experience entry
\NewEnviron{experience}[5]{%
    \sectionwithdetails[\textit{#3}]{#1}{#2}{#4}{#5}%
    \BODY
}

% Skills
\NewDocumentCommand\skills{m m m m m m m m}{
    \begin{minipage}[t]{.24\linewidth}\raggedright\textbf{#1}\par #2\end{minipage}\hfill
    \begin{minipage}[t]{.24\linewidth}\raggedright\textbf{#3}\par #4\end{minipage}\hfill
    \begin{minipage}[t]{.24\linewidth}\raggedright\textbf{#5}\par #6\end{minipage}\hfill
    \begin{minipage}[t]{.24\linewidth}\raggedright\textbf{#7}\par #8\end{minipage}
}

% Project
\NewDocumentCommand\project{m m m m}{
    \textbf{#1}\(\cdot\) \printdotlist{#2}\par
    \textit{#3}\par\smallskip
    #4\par
}
