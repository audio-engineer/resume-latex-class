\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{resume}[2024/11/19 Resume LaTeX class]

\LoadClass[10pt]{article}

\DeclareOption{danish}{\PassOptionsToPackage{danish}{babel}}
\DeclareOption{english}{\PassOptionsToPackage{english}{babel}}

\ExecuteOptions{english}
\ProcessOptions\relax

\RequirePackage[
    a4paper,
    nomarginpar,
    includehead,
    includefoot,
    headheight=1.8cm,
    headsep=0.5cm,
    top=2cm,
    bottom=2cm,
    left=2cm,
    right=2cm,
% showframe
]{geometry}
\RequirePackage{hyphenat}
\RequirePackage{hyperref}
\RequirePackage{textcomp}
\RequirePackage{tabularx}
\RequirePackage{fancyhdr}
\RequirePackage{changepage}
\RequirePackage{environ}
\RequirePackage{enumitem}
\RequirePackage{fontawesome5}

\hypersetup{
    colorlinks=true,
    pdfborder={0 0 0}
}

\raggedright{}

\pagestyle{fancy}
\fancyhead{}
\fancyfoot{}

% Remove spacing before and after itemize
\setlist{nosep,before=,after=}

% Remove header divider line
\renewcommand{\headrulewidth}{0pt}

% Variable for spacing under segments
\newcommand{\spaceunder}{\vspace*{1.1em}}

% Print comma-separated list as dot-separated list
\ExplSyntaxOn{}
\newcommand{\printdotlist}[1]
{
    \seq_set_split:Nnn \l_tmpa_seq {,} { #1 }
    \seq_use:Nn \l_tmpa_seq { ~\(\cdot\)~ }
}
\ExplSyntaxOff{}

% Horizontal line under section headers
\newcommand{\lineunder}{%
    \vspace*{-8pt} \\
    \hrulefill{} \\
}

% Header
\newcommand{\header}[3]{%
    \fancyhead[C]{%
            {\LARGE \scshape {#1}} \\
        \vspace*{2mm}
        {\Large #2} \\
        \vspace*{2mm}
        \printdotlist{#3}
    }
}

% Section header
\newcommand{\sectionheader}[1]{{\large\textsc{#1}}\lineunder\vspace{0em}}

% Section content wrapper
\NewEnviron{sectioncontent}[1]{%
    \sectionheader{#1}
    \begin{adjustwidth}{1.5em}{0pt}
        \BODY{}
    \end{adjustwidth}
    \spaceunder{}
}

% Section content with title, city, details, and from and to dates
\newcommand{\sectionwithdetails}[5][]{%
    \textbf{#2} \hfill #3 \\
    #1 \hfill #4--- #5 \\
}

% Experience entry
\newenvironment{experience}[5]{%
    \sectionwithdetails[\textit{#3}]{#1}{#2}{#4}{#5}
    }{}

% Skills
\newcommand{\skills}[4]{%
    \begin{minipage}[t]{.49\linewidth}
    \raggedright{}
    \textbf{#1} \\
    #2
    \end{minipage}
    \hfill
    \begin{minipage}[t]{.49\linewidth}
    \raggedright{}
    \textbf{#3} \\
    #4
    \end{minipage}
}

% Project
\newcommand{\project}[4]{%
    \textbf{#1}\(\cdot\) \printdotlist{#2} \\
    \textit{#3} \\
    \vspace*{0.5em}
    #4
}
