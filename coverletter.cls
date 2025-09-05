% cSpell:disable
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{coverletter}[2025/08/11 Cover Letter LaTeX class]

% Options
\DeclareOption{english}{\def\coverletter@mainlang{english}}
\DeclareOption{danish}{\def\coverletter@mainlang{danish}}
\DeclareOption*{\PassOptionsToPackage{\CurrentOption}{babel}}
\ExecuteOptions{english}
\ProcessOptions\relax

% Packages
\LoadClass[10pt]{article}

\RequirePackage[main=\coverletter@mainlang, english, danish]{babel}
\RequirePackage[dvipsnames]{xcolor}
\RequirePackage{geometry, fontspec, microtype, fancyhdr, environ, parskip, graphicx, hyperref}

% Font
\defaultfontfeatures{Ligatures=TeX, Scale=MatchLowercase}
\setmainfont{TeX Gyre Pagella}
\setsansfont{TeX Gyre Heros}
\setmonofont{Fira Mono}

% Geometry
\geometry{
    a4paper,
    includehead,
    includefoot,
    headheight=4.2cm,
    margin=1in,
    % showframe
}

% Hyperref
\hypersetup{
    colorlinks=true,
    linkcolor=DarkRed,
    urlcolor=RoyalBlue,
    pdfborder={0 0 0}
}

% Data
\newcommand\coverletter@def[2]{\expandafter\def\csname #1\endcsname{#2}}

\coverletter@def{@sendername}{}
\coverletter@def{@sendertitle}{}
\coverletter@def{@senderaddress}{}
\coverletter@def{@senderphone}{}
\coverletter@def{@senderemail}{}
\coverletter@def{@senderlinkedin}{}
\coverletter@def{@sendergithub}{}
\coverletter@def{@recipientname}{}
\coverletter@def{@recipientaddr}{}
\coverletter@def{@sendername}{}
\coverletter@def{@letterdate}{\today}
\coverletter@def{@subject}{}
\coverletter@def{@greeting}{\babelensuretext{en}{Dear Sir or Madam,}}
\coverletter@def{@closing}{\babelensuretext{en}{Sincerely,}}
\coverletter@def{@signatureimagepath}{}
\coverletter@def{@signature}{\@sendername}

% Macros
\NewDocumentCommand{\SenderName}{m}{\coverletter@def{@sendername}{#1}}
\NewDocumentCommand{\SenderTitle}{m}{\coverletter@def{@sendertitle}{#1}}
\NewDocumentCommand{\SenderAddress}{m}{\coverletter@def{@senderaddress}{#1}}
\NewDocumentCommand{\SenderPhone}{m}{\coverletter@def{@senderphone}{#1}}
\NewDocumentCommand{\SenderEmail}{m}{\coverletter@def{@senderemail}{#1}}
\NewDocumentCommand{\SenderLinkedIn}{m}{\coverletter@def{@senderlinkedin}{#1}}
\NewDocumentCommand{\SenderGitHub}{m}{\coverletter@def{@sendergithub}{#1}}

\NewDocumentCommand{\RecipientName}{m}{\coverletter@def{@recipientname}{#1}}
\NewDocumentCommand{\RecipientAddress}{m}{\coverletter@def{@recipientaddr}{#1}}

\NewDocumentCommand{\LetterDate}{m}{\coverletter@def{@letterdate}{#1}}
\NewDocumentCommand{\Subject}{m}{\coverletter@def{@subject}{#1}}
\NewDocumentCommand{\Greeting}{m}{\coverletter@def{@greeting}{#1}}
\NewDocumentCommand{\Closing}{m}{\coverletter@def{@closing}{#1}}
\NewDocumentCommand{\SignatureImagePath}{m}{\coverletter@def{@signatureimagepath}{#1}}
\NewDocumentCommand{\Signature}{m}{\coverletter@def{@signature}{#1}}

% Header and Footer
\pagestyle{fancy}
\fancyhf{}
\fancyhead[L]{%
    \raggedright\small
    {\Large\scshape\@sendername}\par
    {\large\scshape\@sendertitle}\par
    \addvspace{0.5\baselineskip}
    \@senderaddress\par
    \addvspace{0.5\baselineskip}
    \@senderphone\par
    \@senderemail\par
    \addvspace{0.5\baselineskip}
    \@senderlinkedin\par
    \@sendergithub
}
\fancyhead[R]{}
\fancyfoot[C]{\thepage}

% Body
\NewEnviron{coverletter}{%
    % Date + inside address
    \begingroup
    \raggedright
    \@letterdate\par
    \addvspace{\baselineskip}
    {\bfseries \@recipientname}\par
    \@recipientaddr\par
    \endgroup
    \addvspace{2\baselineskip}

    % Subject
    {\Large\bfseries \@subject}\par
    \addvspace{2\baselineskip}

    % Greeting
    \@greeting\par
    \addvspace{\baselineskip}

    % Body
    \BODY\par
    \addvspace{\baselineskip}

    % Closing and Signature
    \@closing\par
    \includegraphics[scale=0.05]{\@signatureimagepath}\par
    \@signature\par
}
