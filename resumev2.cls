% cSpell:disable
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{resumev2}[2026/03/02 Resume LaTeX class]

% kvoptions
\RequirePackage{kvoptions}

\SetupKeyvalOptions{
    family=resume,
    prefix=res@
}

\DeclareVoidOption{english}{\def\res@mainlang{english}}
\DeclareVoidOption{danish}{\def\res@mainlang{danish}}
\providecommand\res@mainlang{english}

\newif\ifres@ats
\res@atsfalse
\DeclareVoidOption{ats}{\res@atstrue}

\newif\ifres@copyfix
\res@copyfixfalse
\DeclareVoidOption{copyfix}{\res@copyfixtrue}

\DeclareStringOption[1in]{top}
\DeclareStringOption[1in]{bottom}
\DeclareStringOption[1in]{left}
\DeclareStringOption[1in]{right}

\ProcessKeyvalOptions*

% Packages
\LoadClass[10pt]{article}

\RequirePackage[main=\res@mainlang, english, danish]{babel}
\RequirePackage[dvipsnames]{xcolor}

\ifres@copyfix
    \RequirePackage{accsupp}
\fi

\RequirePackage{
    geometry,
    changepage,
    fontspec,
    microtype,
    enumitem,
    tabularx,
    fontawesome5,
    environ,
    ragged2e,
    hyperref
}

% Font
\defaultfontfeatures{Ligatures=TeX, Scale=MatchLowercase}
\setmainfont{TeX Gyre Pagella}
\setsansfont{TeX Gyre Heros}
\setmonofont{Fira Mono}

% Geometry
\geometry{
    a4paper,
    nomarginpar,
    includefoot,
    footskip=0.5cm,
    top=\res@top,
    bottom=\res@bottom,
    left=\res@left,
    right=\res@right,
    % showframe
}

% Global paragraph shape
\setlength{\parindent}{0pt}
\setlength{\parskip}{0pt}
\setlength{\emergencystretch}{2em}

% Reduce/avoid hyphenation
\hyphenpenalty=10000
\exhyphenpenalty=10000

% Hyperref
\hypersetup{
    colorlinks=true,
    linkcolor=DarkRed,
    urlcolor=RoyalBlue,
    pdfborder={0 0 0}
}
\urlstyle{same}

% Copy/paste replacement helpers (ActualText)
\ifres@copyfix
    \NewDocumentCommand{\res@ActualText}{ m m }{%
        \BeginAccSupp{method=plain, ActualText={#1}}#2\EndAccSupp{}%
    }
\else
    \NewDocumentCommand{\res@ActualText}{ m m }{#2}
\fi

% Separators
\ifres@ats
    % In ATS mode, the list separator is comma + whitespace
    \NewDocumentCommand{\res@listsep}{}{, }
\else
    % In copyfix mode, dots are copied as comma + whitespace
    \NewDocumentCommand{\res@listsep}{}{\res@ActualText{, }{\nobreakspace\textperiodcentered{}\space\allowbreak}}
\fi

% In ATS mode, lists use -, while in copytext mode they are copied as -
\NewDocumentCommand{\resItemLabel}{}{%
    \ifres@ats
        -%
    \else
        \ifres@copyfix
            \res@ActualText{- }{\textbullet}%
        \else
            \textbullet
        \fi
    \fi
}

% Remove spacing before and after itemize
\setlist[itemize]{nosep, before=\RaggedRight, after=\relax, itemsep=1pt, leftmargin=1.2em, label=\resItemLabel}

% Header and Footer
\pagestyle{empty}

% Print comma-separated list using the configured separator (\res@listsep),
% while trimming spaces and ignoring empty items (e.g., from trailing commas)
\ExplSyntaxOn
\seq_new:N \l_resume_tmpa_seq
\seq_new:N \l_resume_tmpb_seq
\tl_new:N  \l_resume_tmpa_tl

\NewDocumentCommand\printdotlist{m}
{
    \seq_set_split:Nnn \l_resume_tmpa_seq {,} { #1 }
    \seq_clear:N \l_resume_tmpb_seq
    \seq_map_inline:Nn \l_resume_tmpa_seq
    {
        \tl_set:Nn \l_resume_tmpa_tl { ##1 }
        \tl_trim_spaces:N \l_resume_tmpa_tl
        \tl_if_blank:VTF \l_resume_tmpa_tl
        { }
        { \seq_put_right:NV \l_resume_tmpb_seq \l_resume_tmpa_tl }
    }
    \seq_use:Nn \l_resume_tmpb_seq { \res@listsep }
}
\ExplSyntaxOff

% Horizontal line under section headers
\NewDocumentCommand{\lineunder}{}{\vspace*{-0.6\baselineskip}\noindent\hrulefill\par}

% Header
\NewDocumentCommand\header{m m m}{%
    \begin{center}%
        {\LARGE\scshape #1\par}%
        {\Large \printdotlist{#2}\par\addvspace{0.4\baselineskip}}%
        \printdotlist{#3}\par%
    \end{center}%
    % \vspace{0.2\baselineskip}%
}

% Section header
\NewDocumentCommand\sectionheader{m}{
    \addvspace{0.5\baselineskip}%
    {\large\textsc{#1}}\par\lineunder
}

% Section content wrapper
\NewEnviron{sectioncontent}[1]{%
    \RaggedRight\sectionheader{#1}%
    \begin{adjustwidth}{1.5em}{0pt}%
        \BODY
    \end{adjustwidth}
}

% Section content with title, city, details, and from and to dates
\ExplSyntaxOn
\NewDocumentCommand{\res@sectionwithdetails@ats}{O{} m m m m}{%
    % Linear, extraction-friendly order:
    % Title - Location
    % Details (optional)
    % Dates
    \textbf{#2}%
    \tl_if_blank:nF {#3} {\textemdash{}\space #3}%
    \par
    \tl_if_blank:nF {#1} {#1\par}%
    #4\textendash{}#5\par
}
\ExplSyntaxOff

\NewDocumentCommand{\res@sectionwithdetails@pretty}{O{} m m m m}{%
    \begin{tabularx}{\linewidth}{@{}X r@{}}%
        \textbf{#2} & #3                \\
        #1          & #4\textendash{}#5 \\
    \end{tabularx}\par
}

\NewDocumentCommand{\sectionwithdetails}{O{} m m m m}{%
    \ifres@ats
        \res@sectionwithdetails@ats[#1]{#2}{#3}{#4}{#5}%
    \else
        \res@sectionwithdetails@pretty[#1]{#2}{#3}{#4}{#5}%
    \fi
}

% Experience entry
\NewEnviron{experience}[5]{%
    \sectionwithdetails[\textit{#3}]{#1}{#2}{#4}{#5}%
    \par\medskip
    \BODY
}

% Skills
\NewDocumentCommand\skills{m m m m m m m m}{
    \begin{minipage}[t]{.24\linewidth}\RaggedRight\textbf{#1}\par #2\end{minipage}\hfill
    \begin{minipage}[t]{.24\linewidth}\RaggedRight\textbf{#3}\par #4\end{minipage}\hfill
    \begin{minipage}[t]{.24\linewidth}\RaggedRight\textbf{#5}\par #6\end{minipage}\hfill
    \begin{minipage}[t]{.24\linewidth}\RaggedRight\textbf{#7}\par #8\end{minipage}
}

\NewDocumentCommand\skillline{m m}{%
    \textbf{#1}: #2\par
}

% Project
\ExplSyntaxOn
\cs_if_exist:NT \faGithub
{
    \cs_new_eq:NN \res_orig_faGithub \faGithub

    \RenewDocumentCommand{\faGithub}{}{%
        \ifres@ats
            GitHub:
        \else
            \ifres@copyfix
                \res@ActualText{GitHub: }{ \res_orig_faGithub }%
            \else
                \res_orig_faGithub
            \fi
        \fi
    }
}
\ExplSyntaxOff

\NewDocumentCommand\project{m m m m}{
    \textbf{#1}\res@listsep\printdotlist{#2}\par
    \textit{#3}\par\smallskip
    #4\par
}

\NewDocumentCommand{\entrysubblock}{O{1.5em} +m}{%
    \par\smallskip
    \begin{adjustwidth}{#1}{0pt}%
        #2%
    \end{adjustwidth}%
}
