\usepackage{array}
\usepackage{lastpage}
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{hcmut-report}

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions\relax
\LoadClass[12pt,a4paper]{article}

\RequirePackage[utf8]{vntex,inputenc}
\RequirePackage{anyfontsize,amsmath,amssymb}
\RequirePackage[T5]{fontenc}

\RequirePackage{geometry,graphicx,indentfirst,setspace}
\RequirePackage{booktabs}
\RequirePackage[center]{caption}

\RequirePackage{fancyhdr,hyperref}
\RequirePackage[super,square,sort]{natbib}

% Change to '[english,vietnamese]' to use Vietnamese labels
\RequirePackage[vietnamese]{babel}


\newcommand{\@upperuniname}{ĐẠI HỌC QUỐC GIA THÀNH PHỐ HỒ CHÍ MINH}
\newcommand{\@uniname}{TRƯỜNG ĐẠI HỌC BÁCH KHOA - ĐHQG-HCM}

\newcommand{\@deptname}{KHOA KHOA HỌC VÀ KỸ THUẬT MÁY TÍNH}
\newcommand{\deptname}[1]{\renewcommand{\@deptname}{#1}}

\newcommand{\@coursename}{Course name}
\newcommand{\coursename}[1]{\renewcommand{\@coursename}{#1}}

\newcommand{\@coursecode}{CO0000}
\newcommand{\coursecode}[1]{\renewcommand{\@coursecode}{#1}}

\newcommand{\@reporttype}{Assignment Report}
\newcommand{\reporttype}[1]{\renewcommand{\@reporttype}{#1}}

\newcommand{\@topiccode}{}
\newcommand{\topiccode}[1]{\renewcommand{\@topiccode}{#1}}

\renewcommand{\@title}{Report title}

\newcommand{\@advisor}{Advisor}
\newcommand{\advisor}[1]{\renewcommand{\@advisor}{#1}}


\newcommand{\@class}{Class}
\newcommand{\class}[1]{\renewcommand{\@class}{#1}}

\newcommand{\@stuname}{STUDENT:\ H (xxxxxxx)}
\newcommand{\stuname}[1]{\renewcommand{\@stuname}{#1}}

\newcommand{\@reportplace}{Tp. Hồ Chí Minh}
\newcommand{\reportplace}[1]{\renewcommand{\@reportplace}{#1}}

\newcommand{\@reporttime}{Tháng 09/2026}
\newcommand{\reporttime}[1]{\renewcommand{\@reporttime}{#1}}

% Footer text (short course label shown at bottom-left of every page)
\newcommand{\@footertext}{Đồ án môn học Kỹ thuật Máy tính - CO4041 - HK261}
\newcommand{\footertext}[1]{\renewcommand{\@footertext}{#1}}

% Configurations
%\graphicspath{{subdir1/}{subdir2/}{subdir3/}...{subdirn/}}

\geometry{
  paper=a4paper,
  left=3cm,
  right=2cm,
  vmargin=2cm,
  includeheadfoot=true,
  headheight=35.45059pt
}

\onehalfspacing
\raggedbottom
\renewcommand{\arraystretch}{1.2}

% Set depth of numbering for sections and table of contents
\setcounter{secnumdepth}{3}
\setcounter{tocdepth}{3}

% Set depth of numbering for counters
\AtBeginDocument{\counterwithin{equation}{section}}
\AtBeginDocument{\counterwithin{table}{section}}
\AtBeginDocument{\counterwithin{figure}{section}}

\AtBeginDocument{\renewcommand*\bibname{References}}

\hypersetup{
  colorlinks=true,
  linkcolor=black,
  citecolor=red,
  urlcolor=blue
}

\renewcommand{\headrulewidth}{0.3pt}
\renewcommand{\footrulewidth}{0pt}

\pagestyle{fancy}
\fancyhf{}

%\renewcommand{\subsectionmark}[1]{\markright{\thesubsection.\ #1}}

\fancyhead[L]{
  \bfseries
  \begin{tabular}{rl}
    \begin{picture}(25pt,15pt)
      \put(0,-8pt){\includegraphics[width=20pt]{graphics/hcmut.png}}
    \end{picture}
    \begin{tabular}{l}
      \ttfamily\@uniname \\
      \ttfamily\@deptname \\
    \end{tabular}
  \end{tabular}
}



\fancyhead[R]{
    \begin{tabular}{l}
        \tiny \bf \\
        \tiny \bf
    \end{tabular}
}
\fancyfoot{}
\fancyfoot[L]{\scriptsize \ttfamily \@footertext}
\fancyfoot[R]{\scriptsize \ttfamily Trang {\thepage}/\pageref{LastPage}}
\renewcommand{\headrulewidth}{0.3pt}
\renewcommand{\footrulewidth}{0.3pt}



% Custom pages and sections
\newcommand{\coverpage}{
  \pagestyle{empty}

  \vspace*{-3\baselineskip}
  \begin{center}
    \MakeUppercase{\@upperuniname}

    \MakeUppercase{\ Trường đại học Bách Khoa}

    \MakeUppercase{\ \textbf{Khoa khoa học và kĩ thuật máy tính}}
    \vfill
    \includegraphics[scale=0.4]{graphics/hcmut.png}
    \vfill
    \bfseries
    {\large \parbox{0.9\linewidth}{\centering \@coursename}}\\[4pt]
    {\large \@coursecode}\\[10pt]
    \rule{0.7\linewidth}{0.4pt}\\[10pt]
    {\Large \@reporttype}\\[12pt]
    {\normalsize Mã đề tài: \@topiccode}\\[4pt]
    {\large \parbox{0.9\linewidth}{\centering \MakeUppercase{\@title}}}\\[10pt]
    \rule{0.7\linewidth}{0.4pt}
    \vfill
    \mdseries
      \textbf{Giảng viên hướng dẫn: \@advisor} \\
    \vfill
    \begin{minipage}{\linewidth}
    \centering
    \renewcommand{\arraystretch}{1.8}
    \begin{tabular}{|>{\centering\arraybackslash}m{2cm}|>{\centering\arraybackslash}m{7cm}|>{\centering\arraybackslash}m{3cm}|}
    \hline
    \textbf{STT} & \textbf{Họ tên SV} & \textbf{MSSV}  \\ \hline
    1 & Lê Thanh Phú & 2212581  \\ \hline
    2 & Phan Trần Nguyên Phúc & 2212643  \\ \hline
    3 & Hoàng Ngô Thiên Phúc & 2212612  \\ \hline
    \end{tabular}
    \end{minipage}
    \vfill
    \MakeUppercase{\@reportplace, \@reporttime}
  \end{center}

   \clearpage
  \pagestyle{fancy}
}
