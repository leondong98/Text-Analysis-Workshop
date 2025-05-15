---
title: 25 Text Analysis Seminar 1

---

# 研讨会1: 文本作为数据A

讲座人：Hanxu hanxu.dong.21@ucl.ac.uk

<a href="https://github.com/leondong98/Text-Analysis-Workshop/raw/main/data/mft_dictionary.csv" download>
  <button style="background-color:#4CAF50; color:white; padding:10px 20px; margin-right:10px; border:none; border-radius:4px;">
    Seminar data 1
  </button>
</a>
<a href="https://github.com/leondong98/Text-Analysis-Workshop/raw/main/data/mft_texts.csv" download>
  <button style="background-color:#F57C00; color:white; padding:10px 20px; border:none; border-radius:4px;">
    Seminar data 2
  </button>
</a>


## 1.1 研讨会介绍
本次研讨课旨在引导学生实际操作 [quanteda](https://quanteda.io) 套件及若干相关 R 语言程序包。课程重点包括：探索该套件的基本功能，将文本导入并转换为语料库（corpus）对象格式，学习如何将文本转化为文档-特征矩阵（document-feature matrices, DFM），在此基础上开展描述性分析，并尝试构建与验证字典工具（dictionaries）以支持文本分析研究。

对于R语言，请参考我们day1讨论的 R 语言入门（链接施工中...）。

## 1.2 道德情感的测量
“道德基础理论”（Moral Foundations Theory）是一种社会心理学理论，认为人们的道德判断基于五种彼此独立的道德价值。这五种基础（如下表所列）分别是：关怀/伤害（care/harm）、公正/欺骗（fairness/cheating）、忠诚/背叛（loyalty/betrayal）、权威/颠覆（authority/subversion）以及神圣/堕落（sanctity/degradation）。

根据该理论，人们在面对不同的议题和情境时，会依据这些道德基础进行判断。此外，该理论指出，不同个体对于这五种价值的重视程度存在差异，而这种差异有助于解释人们在道德判断上的文化性和个体性差异。

下表提供了这五项道德基础的简要概述：

| 基础 | 介绍                                                                 |
|------------|------------------------------------------------------------------------------|
| Care       | Concern for caring behaviour, kindness, compassion                          |
| Fairness   | Concern for fairness, justice, trustworthiness                               |
| Authority  | Concern for obedience and deference to figures of authority (religious, state, etc) |
| Loyalty    | Concern for loyalty, patriotism, self-sacrifice                              |
| Sanctity   | Concern for temperance, chastity, piety, cleanliness                         |


我们能否从文本中识别出道德基础的使用？在政治论辩中，道德框架与修辞策略发挥着重要作用。而根深蒂固的道德分歧常被认为是政治极化，尤其是在网络环境中加剧的重要根源。在我们探讨诸如“不同政治立场的群体在道德语言使用上是否存在显著差异”（[案例](https://psycnet.apa.org/record/2009-05192-002?doi=1)）或“道德论证是否有助于缓解政治极化”（[案例](http://kmunger.github.io/pdfs/jmp.pdf)）等关键研究问题之前，前提是我们必须能够在大规模文本中对道德语言的使用进行有效测量。

因此，在本次研讨课中，我们将采用一种简化的字典分析方法，以衡量一组在线文本中所体现的道德语言使用程度。该方法将依据“道德基础理论”中所界定的不同类型道德价值，评估文本内容与相应道德框架之间的契合程度。


## 1.3.1 数据集

在本节研讨会中，我们会使用两个数据集：

**1. Moral Foundations Dictionary** – ``mft_dictionary.csv``

  - 该数据集收录了一系列被认为能指示文本中不同道德关切的词汇列表。该字典最初由 Jesse Graham 与 Jonathan Haidt 开发，并在其[相关论文](https://psycnet.apa.org/record/2009-05192-002?doi=1)中有更为详尽的介绍。
  - 字典共划分为五类道德关切维度：权威（authority）、忠诚（loyalty）、神圣（sanctity）、公正（fairness）与关怀（care），每一类均对应一组特定的代表性词汇，用于识别该类道德语义在文本中的体现。

2. **Moral Foundations Reddit Corpus** – ``mft_texts.csv``

 - 本文件包含 17,886 条英文 Reddit 评论，这些评论由 11 个不同的子版块（subreddits）中精选而来。评论内容涵盖多种不同主题。此外，该数据集还包含由专业标注员手工完成的注释，标注依据为“道德基础理论”中定义的各类道德关切维度。

在下载并妥善保存这些数据文件后，我们可以通过以下R语言指令将其载入工作环境：

```r
mft_dictionary_words <- read_csv("mft_dictionary.csv")
mft_texts <- read_csv("mft_texts.csv")
```


## 1.3.2 Packages
在开始seminar时，我们需要安装并加载以下R语言程序包。

请运行以下代码行以完成这些程序包的安装。**请注意，程序包仅需在本机安装一次；安装完成后，就可以删除这些安装指令：**

```r
install.packages("tidyverse") # Set of packages helpful for data manipulation
install.packages("quanteda") # Main quanteda package
install.packages("quanteda.textplots") # Package with helpful plotting functions
install.packages("quanteda.textstats") # Package with helpful statistical functions
install.packages("remotes") # Package for installing other packages
remotes::install_github("kbenoit/quanteda.dictionaries")
```

在完成上述程序包的安装后，我们还需要加载这些程序包，以便在R Studio中使用其所包含的各类函数。

每当我们希望使用这些程序包的函数时，都需要运行以下代码行来加载它们（此操作在每次新的 R 会话中都需重复执行）：

```r
library(tidyverse)
library(quanteda)
library(quanteda.textplots)
library(quanteda.textstats)
library(quanteda.dictionaries)
```


## 1.4 建立一个Corpus

### 1.4.1 怎么寻求帮助？

用R编程往往是一个令人沮丧的经历。幸运的是，当我们遇到困难时，有很多方法可以寻求帮助。

 - 官方网站 [http://quanteda.io](http://quanteda.io) 提供了详尽的文档与使用说明。
 - 你可以通过输入 ``?function_name`` 的形式，查阅任意函数的帮助文档。
 - 此外，还可以使用 ``example()`` 函数来运行某一函数的示例代码，以观察其具体的用法与效果。

例如，若要查阅 ``corpus()`` 函数的帮助文档，可使用以下代码：

```r
?corpus
```

### 1.4.2 建立一个corpus及corpus结构

在 ``quanteda`` 中，corpus 对象是我们开展一切文本分析工作的基础。因此，在将文本数据加载至 R 环境后，首要步骤是使用 ``corpus()`` 函数将其转换为语料库格式。

1. 创建语料库最简单的方式，是直接使用 R 全局环境中已有的一组文本对象。在本例中，我们已加载 ``mft_texts.csv`` 文件，并将其存储为 ``mft_texts`` 对象。我们可以先查看这个对象的内容，了解其结构。请使用 ``head()`` 函数作用于 ``mft_texts`` 对象，并记录其输出结果。思考：哪个变量字段包含了 Reddit 评论的正文文本？


```r
head(mft_texts)
```

<details>
<summary>Click to show output</summary>

<pre style="overflow-x: auto; max-height: 400px; white-space: pre; font-family: monospace; background-color: #f8f8f8; padding: 1em; border-radius: 6px;">

# A tibble: 6 × 9
  ...1 text              subreddit  care authority loyalty sanctity fairness non_mor
  <dbl> <chr>            <chr>      <lgl> <lgl>     <lgl>   <lgl>    <lgl>    <lgl>   
1 1     Alternati…       worldnews  FALSE FALSE     FALSE   FALSE    FALSE    TRUE
2 2     Dr. Rober…       politics   FALSE TRUE      FALSE   FALSE    TRUE     TRUE
3 3     If you pr…       worldnews  FALSE FALSE     FALSE   FALSE    FALSE    TRUE
4 4     Ben Judah…       geopolit… FALSE TRUE      FALSE   FALSE    TRUE     FALSE
5 5     Ergo, he…        neoliber… FALSE FALSE     TRUE    FALSE    FALSE    TRUE
6 6     He looks …        nostalgia FALSE FALSE     FALSE   FALSE    FALSE    TRUE

</pre> 
    
</details>


> 输出结果显示，该对象是一个 “tibble” —— 这是一种特殊类型的 ``data.frame`` 数据结构。我们可以查看该数据框前六行的内容。其中，名为 ``text`` 的列包含了 Reddit 评论的正文文本。


2. 请使用 ``corpus()`` 函数对这组文本数据进行处理，以创建一个新的语料库对象。``corpus()`` 函数的第一个参数应为 ``mft_texts`` 对象；同时，还需设置 ``text_field`` 为 ``"text"``，以便 quanteda 知道我们感兴趣的文本内容存储在哪一个变量列中。

```r
mft_corpus <- corpus(mft_texts, text_field = "text")
```
\
3. 在成功构建语料库对象之后，请使用 summary() 函数对该语料库进行简要描述，以查看其基本信息和结构摘要。思考：在这些 subreddit 名称中，你觉得哪个最有趣、最具创意或最令人发笑？

```r
summary(mft_corpus)
```

<details>
<summary>Click to show output</summary>

<pre style="overflow-x: auto; max-height: 400px; white-space: pre; font-family: monospace; background-color: #f8f8f8; padding: 1em; border-radius: 6px;">

Corpus consisting of 17886 documents, showing 100 documents:

    Text Types Tokens Sentences ...1           subreddit  care authority
   text1    67    101         7    1           worldnews FALSE     FALSE
   text2    59     72         2    2            politics FALSE      TRUE
   text3    81    177         3    3           worldnews FALSE     FALSE
   text4    65     82         5    4         geopolitics FALSE      TRUE
   text5    22     22         2    5          neoliberal FALSE     FALSE
   text6    21     28         2    6           nostalgia FALSE     FALSE
   text7    22     24         3    7           worldnews  TRUE     FALSE
   text8    41     44         3    8 relationship_advice  TRUE     FALSE
   text9    20     21         1    9       AmItheAsshole FALSE      TRUE
  text10    12     12         2   10            antiwork FALSE     FALSE
  text11    35     43         3   11              europe FALSE     FALSE
  text12    35     40         2   12          confession FALSE     FALSE
  text13    38     43         2   13 relationship_advice  TRUE     FALSE
  text14    46     62         2   14           worldnews  TRUE     FALSE
  text15    57     88         4   15            antiwork FALSE     FALSE
  text16    16     17         1   16           worldnews FALSE     FALSE
  text17    21     22         3   17       AmItheAsshole  TRUE     FALSE
  text18    20     21         3   18          neoliberal FALSE      TRUE
  text19    22     24         1   19            politics FALSE      TRUE
  text20    19     21         3   20          confession FALSE     FALSE
  text21    48     58         1   21            antiwork  TRUE     FALSE
  text22    78    115         4   22            politics FALSE     FALSE
  text23    12     13         1   23        Conservative FALSE     FALSE
  text24    38     66         1   24            antiwork FALSE     FALSE
  text25    18     26         2   25          confession FALSE     FALSE
  text26    22     32         1   26            politics FALSE     FALSE
  text27    70    103         7   27       AmItheAsshole  TRUE     FALSE
  text28    66     92         5   28           worldnews FALSE     FALSE
  text29    43     57         3   29          confession FALSE     FALSE
  text30    35     42         3   30       AmItheAsshole FALSE     FALSE
  text31    44     52         3   31           worldnews  TRUE     FALSE
  text32    31     39         4   32            antiwork FALSE     FALSE
  text33    20     24         2   33            antiwork  TRUE     FALSE
  text34    33     39         2   34            antiwork FALSE      TRUE
  text35    19     24         1   35          confession FALSE     FALSE
  text36    11     14         1   36        Conservative FALSE     FALSE
  text37    21     24         2   37           worldnews FALSE     FALSE
  text38    73    104         6   38 relationship_advice  TRUE      TRUE
  text39    32     41         3   39            antiwork FALSE     FALSE
  text40    73     95         2   40          neoliberal FALSE     FALSE
  text41    27     29         2   41        Conservative FALSE     FALSE
  text42    11     13         1   42            politics FALSE     FALSE
  text43    37     48         2   43              europe FALSE     FALSE
  text44    66    101         6   44           worldnews FALSE     FALSE
  text45    11     13         1   45            antiwork FALSE     FALSE
  text46    50     66         1   46            politics FALSE     FALSE
  text47    41     49         3   47              europe FALSE      TRUE
  text48    13     16         1   48            politics FALSE      TRUE
  text49    41     52         2   49        Conservative FALSE     FALSE
  text50    39     49         3   50              europe FALSE     FALSE
  text51    14     15         1   51 relationship_advice  TRUE     FALSE
  text52    73    110         3   52           nostalgia FALSE     FALSE
  text53    34     39         3   53          confession FALSE     FALSE
  text54    21     22         1   54        Conservative FALSE     FALSE
  text55    30     33         2   55              europe FALSE      TRUE
  text56    20     21         2   56            politics FALSE     FALSE
  text57    13     15         1   57              europe  TRUE     FALSE
  text58    30     42         5   58           worldnews  TRUE      TRUE
  text59    34     40         2   59          neoliberal FALSE     FALSE
  text60    30     38         4   60          confession FALSE     FALSE
  text61    40     44         3   61           nostalgia FALSE     FALSE
  text62    20     25         1   62        Conservative FALSE     FALSE
  text63    33     38         2   63           worldnews  TRUE     FALSE
  text64    21     31         4   64        Conservative FALSE     FALSE
  text65    28     35         1   65          neoliberal  TRUE      TRUE
  text66    13     14         2   66            antiwork FALSE     FALSE
  text67    11     12         1   67            antiwork  TRUE     FALSE
  text68    14     17         2   68          neoliberal FALSE     FALSE
  text69    18     19         1   69            politics FALSE     FALSE
  text70    15     20         1   70          neoliberal FALSE     FALSE
  text71    40     50         1   71           worldnews FALSE     FALSE
  text72    35     45         1   72           nostalgia FALSE     FALSE
  text73    32     43         2   73       AmItheAsshole  TRUE     FALSE
  text74    32     36         3   74              europe FALSE      TRUE
  text75    38     54         5   75 relationship_advice  TRUE     FALSE
  text76    15     18         1   76        Conservative FALSE      TRUE
  text77    24     25         1   77 relationship_advice  TRUE     FALSE
  text78    20     23         1   78        Conservative FALSE     FALSE
  text79    22     24         3   79            antiwork FALSE     FALSE
  text80    17     21         1   80           worldnews FALSE     FALSE
  text81    36     47         4   81 relationship_advice  TRUE     FALSE
  text82    49     68         1   82            antiwork FALSE     FALSE
  text83    67     82         2   83          confession FALSE     FALSE
  text84    26     32         1   84           worldnews FALSE     FALSE
  text85    25     35         2   85            antiwork FALSE     FALSE
  text86    14     16         1   86            antiwork  TRUE     FALSE
  text87    27     28         1   87       AmItheAsshole  TRUE      TRUE
  text88    18     20         1   88       AmItheAsshole FALSE     FALSE
  text89    33     42         3   89           worldnews FALSE      TRUE
  text90    16     20         1   90          neoliberal FALSE     FALSE
  text91    42     55         3   91            antiwork FALSE     FALSE
  text92    26     30         3   92       AmItheAsshole  TRUE     FALSE
  text93    34     47         2   93        Conservative FALSE     FALSE
  text94    22     28         3   94 relationship_advice  TRUE     FALSE
  text95    53     71         5   95          neoliberal FALSE     FALSE
  text96    38     55         3   96        Conservative FALSE     FALSE
  text97    19     21         2   97           worldnews FALSE      TRUE
  text98    32     34         2   98              europe FALSE     FALSE
  text99    13     15         1   99           worldnews FALSE     FALSE
 text100    19     30         2  100           worldnews FALSE     FALSE
 loyalty sanctity fairness non_moral
   FALSE    FALSE    FALSE      TRUE
   FALSE    FALSE    FALSE      TRUE
   FALSE    FALSE    FALSE      TRUE
   FALSE    FALSE     TRUE     FALSE
    TRUE    FALSE    FALSE      TRUE
   FALSE    FALSE    FALSE      TRUE
   FALSE     TRUE     TRUE      TRUE
    TRUE    FALSE    FALSE      TRUE
   FALSE    FALSE    FALSE      TRUE
   FALSE    FALSE     TRUE      TRUE
   FALSE    FALSE     TRUE      TRUE
   FALSE    FALSE    FALSE      TRUE
   FALSE    FALSE     TRUE     FALSE
   FALSE     TRUE     TRUE      TRUE
   FALSE    FALSE    FALSE      TRUE
    TRUE    FALSE     TRUE      TRUE
   FALSE    FALSE    FALSE      TRUE
   FALSE    FALSE    FALSE      TRUE
   FALSE    FALSE    FALSE      TRUE
   FALSE    FALSE    FALSE      TRUE
   FALSE    FALSE    FALSE      TRUE
    TRUE    FALSE    FALSE      TRUE
   FALSE    FALSE    FALSE      TRUE
   FALSE    FALSE    FALSE      TRUE
   FALSE    FALSE    FALSE      TRUE
   FALSE    FALSE    FALSE      TRUE
   FALSE     TRUE    FALSE     FALSE
    TRUE    FALSE    FALSE      TRUE
   FALSE    FALSE    FALSE      TRUE
   FALSE    FALSE    FALSE      TRUE
   FALSE    FALSE     TRUE      TRUE
   FALSE    FALSE    FALSE      TRUE
   FALSE     TRUE     TRUE      TRUE
   FALSE    FALSE    FALSE      TRUE
   FALSE    FALSE    FALSE      TRUE
   FALSE    FALSE     TRUE      TRUE
   FALSE    FALSE    FALSE      TRUE
   FALSE    FALSE     TRUE     FALSE
   FALSE    FALSE    FALSE      TRUE
   FALSE    FALSE     TRUE      TRUE
   FALSE    FALSE    FALSE      TRUE
   FALSE    FALSE    FALSE      TRUE
   FALSE    FALSE    FALSE      TRUE
   FALSE    FALSE    FALSE      TRUE
   FALSE    FALSE    FALSE      TRUE
   FALSE    FALSE    FALSE      TRUE
   FALSE    FALSE    FALSE      TRUE
   FALSE    FALSE     TRUE      TRUE
   FALSE    FALSE    FALSE      TRUE
    TRUE    FALSE    FALSE      TRUE
   FALSE     TRUE     TRUE      TRUE
   FALSE    FALSE    FALSE      TRUE
   FALSE    FALSE     TRUE      TRUE
   FALSE    FALSE    FALSE      TRUE
   FALSE    FALSE     TRUE      TRUE
   FALSE    FALSE    FALSE      TRUE
   FALSE    FALSE    FALSE      TRUE
   FALSE    FALSE    FALSE      TRUE
   FALSE    FALSE    FALSE      TRUE
   FALSE    FALSE    FALSE      TRUE
   FALSE    FALSE    FALSE      TRUE
   FALSE    FALSE    FALSE      TRUE
   FALSE     TRUE     TRUE      TRUE
   FALSE    FALSE    FALSE      TRUE
   FALSE    FALSE    FALSE      TRUE
   FALSE    FALSE     TRUE      TRUE
   FALSE    FALSE     TRUE      TRUE
   FALSE    FALSE    FALSE      TRUE
   FALSE    FALSE     TRUE     FALSE
   FALSE    FALSE    FALSE      TRUE
   FALSE    FALSE    FALSE      TRUE
   FALSE    FALSE    FALSE      TRUE
   FALSE    FALSE    FALSE     FALSE
   FALSE    FALSE     TRUE     FALSE
   FALSE     TRUE     TRUE     FALSE
    TRUE    FALSE    FALSE     FALSE
   FALSE     TRUE     TRUE     FALSE
   FALSE    FALSE    FALSE      TRUE
   FALSE    FALSE    FALSE      TRUE
   FALSE    FALSE    FALSE      TRUE
   FALSE    FALSE     TRUE      TRUE
   FALSE    FALSE    FALSE      TRUE
   FALSE    FALSE    FALSE      TRUE
   FALSE    FALSE    FALSE      TRUE
   FALSE    FALSE     TRUE      TRUE
   FALSE    FALSE     TRUE      TRUE
   FALSE    FALSE     TRUE      TRUE
   FALSE    FALSE    FALSE      TRUE
   FALSE    FALSE    FALSE      TRUE
   FALSE    FALSE    FALSE      TRUE
   FALSE     TRUE    FALSE      TRUE
    TRUE     TRUE     TRUE     FALSE
   FALSE    FALSE     TRUE      TRUE
    TRUE    FALSE    FALSE     FALSE
   FALSE    FALSE    FALSE      TRUE
   FALSE    FALSE     TRUE      TRUE
   FALSE    FALSE    FALSE     FALSE
   FALSE    FALSE    FALSE      TRUE
    TRUE    FALSE    FALSE      TRUE
   FALSE    FALSE    FALSE      TRUE
</pre>

</details>

\
4. 请注意，尽管我们在构建语料库时指定了 ``text_field = "text"``，但我们并没有移除与文本相关的元数据。为了访问这些其他变量，我们可以将 ``docvars()`` 函数应用于我们上面创建的语料库对象:

```r
head(docvars(mft_corpus))
```
```
...1   subreddit  care authority loyalty sanctity fairness non_moral
1    1   worldnews FALSE     FALSE   FALSE    FALSE    FALSE      TRUE
2    2    politics FALSE      TRUE   FALSE    FALSE    FALSE      TRUE
3    3   worldnews FALSE     FALSE   FALSE    FALSE    FALSE      TRUE
4    4 geopolitics FALSE      TRUE   FALSE    FALSE     TRUE     FALSE
5    5  neoliberal FALSE     FALSE    TRUE    FALSE    FALSE      TRUE
6    6   nostalgia FALSE     FALSE   FALSE    FALSE    FALSE      TRUE
```

## 1.5 Tokenizing texts

为了统计词频，我们首先需要通过一个称为“分词（tokenization）”的过程，将文本拆分为词语（或更长的短语）。请查阅 ``quanteda`` 中关于 ``tokens()`` 函数的文档。

1. 对我们之前创建的语料库对象使用 tokens 命令，并查看其结果:

```r
mft_tokens <- tokens(mft_corpus)
head(mft_tokens)
```

<details>
<summary>Click to show output</summary>

<pre style="overflow-x: auto; max-height: 400px; white-space: pre; font-family: monospace; background-color: #f8f8f8; padding: 1em; border-radius: 6px;">
Tokens consisting of 6 documents and 8 docvars.
text1 :
 [1] "Alternative" "Fact"        ":"           "They"        "argued"     
 [6] "a"           "crowd"       "movement"    "around"      "Ms"         
[11] "Le"          "Pen"        
[ ... and 89 more ]

text2 :
 [1] "Dr"            "."             "Robert"        "Jay"          
 [5] "Lifton"        ","             "distinguished" "professor"    
 [9] "emeritus"      "at"            "John"          "Jay"          
[ ... and 60 more ]

text3 :
 [1] "If"      "you"     "prefer"  "not"     "to"      "click"   "on"     
 [8] "Daily"   "Mail"    "sources" ","       "then"   
[ ... and 165 more ]

text4 :
 [1] "Ben"      "Judah"    "details"  "Emmanuel" "Macron's" "nascent" 
 [7] "foreign"  "policy"   "doctrine" "."        "Noting"   "both"    
[ ... and 70 more ]

text5 :
 [1] "Ergo"     ","        "he"       "supports" "Macron"   "but"     
 [7] "doesn't"  "want"     "to"       "say"      "it"       "out"     
[ ... and 10 more ]

text6 :
 [1] "He"      "looks"   "exactly" "the"     "same"    "in"      "Richie" 
 [8] "Rich"    "as"      "he"      "does"    "as"     
[ ... and 16 more ]
</pre> 
    
</details>


2. 接下来，请尝试使用 ``tokens()`` 函数的一些参数，例如 ``remove_punct`` 和 ``remove_numbers``:

```r
mft_tokens <- tokens(mft_corpus, remove_punct = TRUE, remove_numbers = TRUE)
head(mft_tokens)
```

<details>
<summary>Click to show output</summary>

<pre style="overflow-x: auto; max-height: 400px; white-space: pre; font-family: monospace; background-color: #f8f8f8; padding: 1em; border-radius: 6px;">
Tokens consisting of 6 documents and 8 docvars.
text1 :
 [1] "Alternative" "Fact"        "They"        "argued"      "a"          
 [6] "crowd"       "movement"    "around"      "Ms"          "Le"         
[11] "Pen"         "had"        
[ ... and 72 more ]

text2 :
 [1] "Dr"            "Robert"        "Jay"           "Lifton"       
 [5] "distinguished" "professor"     "emeritus"      "at"           
 [9] "John"          "Jay"           "College"       "and"          
[ ... and 56 more ]

text3 :
 [1] "If"      "you"     "prefer"  "not"     "to"      "click"   "on"     
 [8] "Daily"   "Mail"    "sources" "then"    "here"   
[ ... and 131 more ]

text4 :
 [1] "Ben"      "Judah"    "details"  "Emmanuel" "Macron's" "nascent" 
 [7] "foreign"  "policy"   "doctrine" "Noting"   "both"     "that"    
[ ... and 65 more ]

text5 :
 [1] "Ergo"     "he"       "supports" "Macron"   "but"      "doesn't" 
 [7] "want"     "to"       "say"      "it"       "out"      "loud"    
[ ... and 8 more ]

text6 :
 [1] "He"      "looks"   "exactly" "the"     "same"    "in"      "Richie" 
 [8] "Rich"    "as"      "he"      "does"    "as"     
[ ... and 12 more ]

</pre> 
    
</details>


## 1.6 建立一个``dfm()``

文档-特征矩阵（document-feature matrices）是将文本表示为量化数据的标准方式。幸运的是，在 quanteda 中将 tokens 对象转换为 dfm 非常简单。

1. 请使用 ``dfm`` 函数对你之前创建的分词（tokenized）对象构建一个文档-特征矩阵。我们可以使用 ``?dfm`` 阅读该函数的帮助文档，以了解可用的参数选项。一旦创建完成 ``dfm``，请使用 ``topfeatures()`` 函数来查看该矩阵中出现频率最高的前 20 个特征词。你观察到的都是哪一类词语？

```r
mft_dfm <- dfm(mft_tokens)
mft_dfm
```

<details>
<summary>Click to show output</summary>

<pre style="overflow-x: auto; max-height: 400px; white-space: pre; font-family: monospace; background-color: #f8f8f8; padding: 1em; border-radius: 6px;">

Document-feature matrix of: 17,886 documents, 30,419 features (99.91% sparse) and 8 docvars.
       features
docs    alternative fact they argued a crowd movement around ms le
  text1           2    2    1      1 5     2        2      1  1  2
  text2           0    0    0      0 1     0        0      0  0  0
  text3           1    0    1      0 3     0        0      0  0  0
  text4           0    0    0      0 2     0        0      0  0  0
  text5           0    0    0      0 1     0        0      0  0  0
  text6           0    0    0      0 0     0        0      0  0  0
[ reached max_ndoc ... 17,880 more documents, reached max_nfeat ... 30,409 more features ]

</pre> 
    
</details>


```r
topfeatures(mft_dfm, 20)
```
<details>
<summary>Click to show output</summary>

<pre style="overflow-x: auto; max-height: 400px; white-space: pre; font-family: monospace; background-color: #f8f8f8; padding: 1em; border-radius: 6px;">

the    to   and     a    of    is  that     i   you    in   for    it   not 
22026 17337 14025 12792 11252 10653  8757  8681  8518  6972  6380  6190  5358 
 this    be   are  they   but    le  with 
 4601  4549  4494  4149  4109  3861  3635 

</pre> 
    
</details>


> 基本都是停用词（stop words）

2. 尝试使用不同的 ``dfm_*`` 函数，例如 ``dfm_wordstem()``、``dfm_remove()`` 和 ``dfm_trim()``。这些函数可以在文档-特征矩阵构建完成后，用于缩减其规模。将它们依次应用于你在上一个问题中创建的 dfm 对象，并观察特征数量的变化情况。

```r
dim(mft_dfm)
```

```
[1] 17886 30419
```

```r
dim(dfm_wordstem(mft_dfm))
```

```
[1] 17886 21523
```

```r
dim(dfm_remove(mft_dfm, pattern = c("of", "the", "and")))
```

```
[1] 17886 30416
```

```r
dim(dfm_trim(mft_dfm, min_termfreq = 5, min_docfreq = 0.01, termfreq_type = "count", docfreq_type = "prop"))
```

```
[1] 17886   380
```

3. 请使用 ``dfm_remove()`` 函数从该数据中移除英文停用词。你可以通过以下命令获取英文停用词列表：

```r
stopwords("english")
```

```r
#移除英文停用词
mft_dfm_nostops <- dfm_remove(mft_dfm, pattern = stopwords("english"))
mft_dfm_nostops
```

<details>
<summary>Click to show output</summary>

<pre style="overflow-x: auto; max-height: 400px; white-space: pre; font-family: monospace; background-color: #f8f8f8; padding: 1em; border-radius: 6px;">
Document-feature matrix of: 17,886 documents, 30,247 features (99.94% sparse) and 8 docvars.
       features
docs    alternative fact argued crowd movement around ms le pen become
  text1           2    2      1     2        2      1  1  2   2      1
  text2           0    0      0     0        0      0  0  0   0      0
  text3           1    0      0     0        0      0  0  0   0      0
  text4           0    0      0     0        0      0  0  0   0      0
  text5           0    0      0     0        0      0  0  0   0      0
  text6           0    0      0     0        0      0  0  0   0      0
[ reached max_ndoc ... 17,880 more documents, reached max_nfeat ... 30,237 more features ]
</pre> 
    
</details>


## 1.7 Pipes

在讲座中，我们学习了 ``%>%`` 这个“管道”操作符，它可以将多个函数连接起来，使得一个函数的输出可以直接作为下一个函数的输入。我们可以使用这种管道语法来简化代码，并使其更易阅读。

例如，我们可以使用管道操作符，将先前分别进行的语料库构建与分词步骤合并为一行代码：

```r
mft_tokens <- mft_texts %>% # Take the original data object
  corpus(text_field = "text") %>% # ...convert to a corpus
  tokens(remove_punct = TRUE) #...and then tokenize

mft_tokens[1]
```

<details>
<summary>Click to show output</summary>

<pre style="overflow-x: auto; max-height: 400px; white-space: pre; font-family: monospace; background-color: #f8f8f8; padding: 1em; border-radius: 6px;">
Tokens consisting of 1 document and 8 docvars.
text1 :
 [1] "Alternative" "Fact"        "They"        "argued"      "a"          
 [6] "crowd"       "movement"    "around"      "Ms"          "Le"         
[11] "Pen"         "had"        
[ ... and 72 more ]
</pre> 
    
</details>


1. 使用 ``%>%`` 管道操作符编写的 R 语言代码，依次完成以下任务：a) 创建语料库; b) 对文本进行分词; c) 构建文档-特征矩阵（dfm）; d) 移除停用词; e) 输出出现频率最高的特征词:

```r
mft_texts %>%                           # 获取原始数据对象
  corpus(text_field = "text") %>%       # 转换为语料库
  tokens(remove_punct = TRUE) %>%       # 分词化
  dfm() %>%                             #构建文档-特征矩阵（dfm）
  dfm_remove(pattern = stopwords("english")) %>% # 移除停用词
  topfeatures()                         # 输出出现频率最高的特征词
```

<details>
<summary>Click to show output</summary>

<pre style="overflow-x: auto; max-height: 400px; white-space: pre; font-family: monospace; background-color: #f8f8f8; padding: 1em; border-radius: 6px;">
le    pen macron people   like   just    can  think    get  trump 
  3861   3517   3307   3124   2967   2584   1812   1684   1460   1367 
</pre> 
    
</details>  



## 1.8 描述性统计

1. 使用 ``ntoken()`` 函数来统计语料库中每条文本的词元数量。将该函数的输出赋值给一个新对象，以便后续使用:

```r
mft_n_words <- ntoken(mft_corpus)
```


2. 使用 ``hist()`` 函数绘制直方图，以展示语料库中各文档长度（以词元数计）的分布情况。同时，使用 ``summary()`` 函数报告集中趋势的相关统计量:

```r
hist(mft_n_words)
```
<details>
<summary>Click to show figure</summary>

<img src="https://raw.githubusercontent.com/leondong98/Text-Analysis-Workshop/main/images/1-1.png" width="700"/> 


</details>

```r
summary(mft_n_words)
```

```
 Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
   7.00   20.00   31.00   39.09   53.00  177.00 
```

> Reddit 语料库中评论的中位长度为 31 个词。绘制的图形表明，该语料库中的文档长度分布呈正偏态（positively skewed），也就是说，大多数评论较短，分布的主体集中在左侧，而右尾较长，表明存在少量篇幅较长的评论。

### 1.8.1 创建Dictionary

词典（dictionary）是具名列表（named list），由“键（key）”与一组对应条目组成，这些条目定义了该键的等价类。在 ``quanteda`` 中，词典可通过 ``dictionary()`` 函数创建。该函数的输入是一个列表（list），其中包含若干具名的字符向量（named character vectors）。

例如，假设我们希望构建一个简单的词典，用于衡量与两门课程相关的词语：量化文本分析（quantitative text analysis）与因果推断（causal inference）。我们可以首先为每个概念创建一组相关词汇的向量，并将其存储在一个列表中：

```r
teaching_dictionary_list <- list(qta = c("quantitative", "text", "analysis", "document", "feature", "matrix"),
                                 causal = c("potential", "outcomes", "framework", "counterfactual"))
```

然后我们将该向量传递给 dictionary() 函数：

```r
teaching_dictionary <- dictionary(teaching_dictionary_list)
teaching_dictionary
```

```
Dictionary object with 2 key entries.
- [qta]:
  - quantitative, text, analysis, document, feature, matrix
- [causal]:
  - potential, outcomes, framework, counterfactual
```

我们当然可以扩展类别的数量，并为每个类别添加更多词语。

在开始编码练习之前，请先查看 ``mft_dictionary.csv`` 文件。你认为每个道德基础所关联的词语是否合理？是否有某些词语看起来不太恰当？请记住，构建词典在很大程度上依赖主观判断，所选词汇的范围与内容会对你所进行的任何分析结果产生显著影响！

1. 从 ``mft_dictionary_words`` 数据中的词汇创建一个 quanteda 词典对象。你的词典应包含两个类别——一个对应 “care”(关心)，另一个对应 “sanctity”（神圣）：

```r
mft_dictionary_list <- list(
  care = mft_dictionary_words$word[mft_dictionary_words$foundation == "care"],
  sanctity = mft_dictionary_words$word[mft_dictionary_words$foundation == "sanctity"]
  )

mft_dictionary <- dictionary(mft_dictionary_list)
mft_dictionary
```

```
Dictionary object with 2 key entries.
- [care]:
  - alleviate, alleviated, alleviates, alleviating, alleviation, altruism, altruist, beneficence, beneficiary, benefit, benefits, benefitted, benefitting, benevolence, benevolent, care, cared, caregiver, cares, caring [ ... and 444 more ]
- [sanctity]:
  - abstinance, abstinence, allah, almighty, angel, apostle, apostles, atone, atoned, atonement, atones, atoning, beatification, beatify, beatifying, bible, bibles, biblical, bless, blessed [ ... and 640 more ]
```

2. 使用你在上一个问题中创建的词典，并将其应用于你在本次作业前面创建的文档-特征矩阵。为此，你需要使用 ``dfm_lookup()`` 函数。(如果需要帮助，可以阅该函数的帮助文档``?dfm_lookup``）

```r
mft_dfm_dictionary <- dfm_lookup(mft_dfm, mft_dictionary)
mft_dfm_dictionary
```
<details>
<summary>Click to show output</summary>

<pre style="overflow-x: auto; max-height: 400px; white-space: pre; font-family: monospace; background-color: #f8f8f8; padding: 1em; border-radius: 6px;">
Document-feature matrix of: 17,886 documents, 2 features (78.13% sparse) and 8 docvars.
       features
docs    care sanctity
  text1    0        1
  text2    1        0
  text3    1        0
  text4    1        0
  text5    0        1
  text6    0        0
[ reached max_ndoc ... 17,880 more documents ]
</pre> 
    
</details>  


3. 你刚刚创建的词典-文档矩阵（dictionary-dfm）记录了每条文本中与每个道德基础类别相关的词汇数量。然而，正如我们之前所见，**并非所有文本的词数都相同**。请创建该词典-文档矩阵的一个新版本，其中记录的是每条文本中与各道德基础类别相关的词汇占总词数的比例。

```r
mft_dfm_dictionary_proportions <- mft_dfm_dictionary/mft_n_words
```

4. 将每个道德基础类别的词典得分存储为新的变量，添加到原始的 ``mft_texts`` 数据框中。你需要使用 ``as.numeric`` 函数，将 dfm 中的每一列强制转换为适合存储在 data.frame 中的格式:

```r
mft_texts$care_dictionary <- as.numeric(mft_dfm_dictionary_proportions[,1])
mft_texts$sanctity_dictionary <- as.numeric(mft_dfm_dictionary_proportions[,2])
```

> 请注意，这里的代码只是将应用词典后的输出结果赋值给 ``mft_texts`` 数据框。这只是为了使后续的分析步骤更为简便。


### 1.8.2 有效性检验

现在我们已经构建好了词典指标，接下来将进行一些基本的效度检验。我们将从直接检查在各个道德基础类别中被词典赋予高分的文本开始。

为此，我们需要根据词典分析所赋予的分值对文本进行排序。例如，对于 “care” 基础，可以使用如下代码：

```r
mft_texts$text[order(mft_texts$care_dictionary, decreasing = TRUE)][1:5]
```
> - 方括号运算符``（[]）``允许我们对 ``mft_texts$text`` 变量进行子集提取;
>  - ``order()`` 函数根据 ``mft_texts$care_dictionary`` 变量的数值对观测进行排序，参数 ``decreasing = TRUE`` 表示按从大到小的顺序排列。

1. 在 care 和 sanctity 两个道德基础类别中，词典得分最高的前 5 条文本分别是哪些？

```r
mft_texts$text[order(mft_texts$care_dictionary, decreasing = TRUE)][1:5]
```

<details>
<summary>Click to show output</summary>

<pre style="overflow-x: auto; max-height: 400px; white-space: pre; font-family: monospace; background-color: #f8f8f8; padding: 1em; border-radius: 6px;">
[1] "i doubt she'd want \"help\" from a childhood bully 🙄"
[2] "We are talking about threats to human safety, not threats to property."
[3] "What guarantees adoptive parents would have been loving? That the child wouldn’t suffer" 
[4] "The dress design didn’t have anything to do with child sexual assault victims. https://www.papermag.com/alexander-mcqueen-dancing-girls-dress-2645945769.html"
[5] "This right here. Threatening violence of any kind is not ok, sexual rape violence SO not ok."                                                                 
</pre> 
    
</details>  
    
```r
mft_texts$text[order(mft_texts$sanctity_dictionary, decreasing = TRUE)][1:5]
```

<details>
<summary>Click to show output</summary>

<pre style="overflow-x: auto; max-height: 400px; white-space: pre; font-family: monospace; background-color: #f8f8f8; padding: 1em; border-radius: 6px;">
[1] "hot fucking damn macron this last bit was inspiring as hell"   
[2] "Fuck you. Seriously, fuck you. Get your shit together you fucking junkie."
[3] "Hell yeah! That’s some hardcore nostalgia right there god DAMN."          
[4] "This is so fucking sad. I hate this god damned country"         
[5] "Holy fuck. This makes OP TA forever. How fucking awful."                                                                         
</pre> 
    
</details> 

2. 阅读与 care 和 sanctity 两个道德基础最强相关的文本。你认为这些词典是否准确捕捉了 “关怀” 与 “神圣” 这两个概念？

> 在一些情况下，这些文本与相应的道德基础类别的关联似乎是合理的。例如，许多与 “care” 相关的文本确实涉及对他人伤害的描述。
> 
> 但在其他情况下，词典似乎捕捉到的内容并不准确。例如，所有与 “sanctity” 相关的高分文本几乎都是因为包含脏话。虽然咒骂行为可能在某种程度上与对神圣议题的道德敏感性相关，但它本身并不构成对“神圣”概念的实质性表达，因此这提示我们：sanctity 词典可能仍需改进。

3. ``mft_texts`` 对象中包含了一系列变量，记录了每条文本由人工标注所归类的道德基础类别。请使用 ``table()`` 函数创建一个混淆矩阵 (confusion matrix)，以比较人工标注结果与词典分析生成的得分之间的一致性:

```r
care_confusion <- table( 
  dictionary = mft_texts$care_dictionary > 0,
  human_coding = mft_texts$care)
care_confusion
```

```
          human_coding
dictionary FALSE  TRUE
     FALSE 11248  2553
     TRUE   1898  2187
```

```r
sanctity_confusion <- table(
  dictionary = mft_texts$sanctity_dictionary > 0,
  human_coding = mft_texts$sanctity)
sanctity_confusion
```

```
          human_coding
dictionary FALSE  TRUE
     FALSE 13268   878
     TRUE   2871   869
```

4. 对于每个道德基础类别，分类器的准确率是多少？（如果你忘记了如何计算，请查看Lecture讲义）

```r
# Care
(2187 + 11248)/(2187 + 11248 + 2553 + 1898)
```
```
[1] 0.7511461
```

```r
# Sanctity
(869 + 13268)/(869 + 13268 + 2871 + 878)
```

```
[1] 0.7903947
```

5. 对于每个道德基础类别，分类器的灵敏度（sensitivity）是多少？

```r
# Care
(2187)/(2187 + 2553)
```

```
[1] 0.4613924
```

```r
# Sanctity
869/(869 + 878)
```

```
[1] 0.4974242
```

6. 对于每个道德基础类别，分类器的特异度（specificity）是多少？
```r
# Care
(11248)/(11248 + 1898)
```

```
[1] 0.8556215
```

```r
# Sanctity
13268/(13268 + 2871)
```

```
[1] 0.8221079
```

7. 根据这些数值，我们的词典在分类任务中的表现如何？

> 虽然整体的**准确率（accuracy）看起来相对较高，但从灵敏度（sensitivity）**得分来看，词典在识别真正的 “care” 和 “sanctity” 编码文本方面的表现其实并不理想。
> 
> 具体而言，词典对于这两个类别都未能识别出 50% 以上的真正阳性样本（true positives）。换句话说，虽然词典在多数情况下可能避免了错误分类，但却漏掉了大量真正具有“关怀”或“神圣”特征的文本。
> 
> 这种情况有些类似于一个安检系统，它在避免误报（不把无害物误判为危险品）方面做得不错，但却频繁漏检真正的危险品。这对研究者来说是一个警示：词典虽然提供了一种高效的量化方法，但在覆盖复杂语义和细微道德表达方面，可能存在着结构性不足。

8. 除了以上这种直接手算的方式，我们也可以使用 ``caret`` 程序包非常简便地计算这些统计量:

```r
# install.packages("caret") # 只需要在第一次运行这行代码安装!
library(caret)

confusionMatrix(care_confusion, positive = "TRUE")
```

<details>
<summary>Click to show output</summary>

<pre style="overflow-x: auto; max-height: 400px; white-space: pre; font-family: monospace; background-color: #f8f8f8; padding: 1em; border-radius: 6px;">
Confusion Matrix and Statistics

          human_coding
dictionary FALSE  TRUE
     FALSE 11248  2553
     TRUE   1898  2187
                                          
               Accuracy : 0.7511          
                 95% CI : (0.7447, 0.7575)
    No Information Rate : 0.735           
    P-Value [Acc > NIR] : 4.343e-07       
                                          
                  Kappa : 0.3317          
                                          
 Mcnemar's Test P-Value : < 2.2e-16       
                                          
            Sensitivity : 0.4614          
            Specificity : 0.8556          
         Pos Pred Value : 0.5354          
         Neg Pred Value : 0.8150          
             Prevalence : 0.2650          
         Detection Rate : 0.1223          
   Detection Prevalence : 0.2284          
      Balanced Accuracy : 0.6585          
                                          
       'Positive' Class : TRUE          
</pre> 
    
</details> 


```r
confusionMatrix(sanctity_confusion, positive = "TRUE")
```
<details>
<summary>Click to show output</summary>

<pre style="overflow-x: auto; max-height: 400px; white-space: pre; font-family: monospace; background-color: #f8f8f8; padding: 1em; border-radius: 6px;">
Confusion Matrix and Statistics

          human_coding
dictionary FALSE  TRUE
     FALSE 13268   878
     TRUE   2871   869
                                          
               Accuracy : 0.7904          
                 95% CI : (0.7844, 0.7963)
    No Information Rate : 0.9023          
    P-Value [Acc > NIR] : 1               
                                          
                  Kappa : 0.2118          
                                          
 Mcnemar's Test P-Value : <2e-16          
                                          
            Sensitivity : 0.49742         
            Specificity : 0.82211         
         Pos Pred Value : 0.23235         
         Neg Pred Value : 0.93793         
             Prevalence : 0.09767         
         Detection Rate : 0.04859         
   Detection Prevalence : 0.20910         
      Balanced Accuracy : 0.65977         
                                          
       'Positive' Class : TRUE            
                                                                                                                 
</pre> 
    
</details> 



### 1.8.3 应用

在完成上述验证（尽管词典得分与人工编码的相关性相对较弱）之后，我们现在可以继续进行一个简单的应用。

1. 请计算数据中 11 个 subreddit 各自的 care 和 sanctity 词典得分的平均值：

```r
dictionary_means_by_subreddit <- mft_texts %>%
  group_by(subreddit) %>%
  summarise(care_dictionary = mean(care_dictionary),
            sanctity_dictionary = mean(sanctity_dictionary)) 

dictionary_means_by_subreddit
```

<details>
<summary>Click to show output</summary>

<pre style="overflow-x: auto; max-height: 400px; white-space: pre; font-family: monospace; background-color: #f8f8f8; padding: 1em; border-radius: 6px;">
# A tibble: 11 × 3
   subreddit           care_dictionary sanctity_dictionary
   <chr>                         <dbl>               <dbl>
 1 AmItheAsshole               0.0118              0.00966
 2 Conservative                0.00946             0.0101 
 3 antiwork                    0.0106              0.0120 
 4 confession                  0.0117              0.0127 
 5 europe                      0.00488             0.00453
 6 geopolitics                 0.00394             0.00137
 7 neoliberal                  0.00430             0.00662
 8 nostalgia                   0.00767             0.00959
 9 politics                    0.00923             0.0108 
10 relationship_advice         0.0127              0.0110 
11 worldnews                   0.00651             0.00616
                                                                  
</pre> 
    
</details> 

> ``group_by()`` 是一个特殊函数，它允许我们根据指定变量的分组对数据进行操作（在这里，我们按 subreddit 分组，因为我们希望了解每个 subreddit 的词典得分均值）
> 
> ``summarise()`` 是一个函数，可用于对数据计算各种类型的汇总统计量。

2.对你刚刚计算出的 subreddit 平均值进行解释，或许将这些信息以可视化图形形式展示出来更直观：

```r
dictionary_means_by_subreddit %>%
  # 将数据转换成"long format"以便于绘制图表
  pivot_longer(-subreddit) %>%
  # 使用 ggplot
  ggplot(aes(x = name, y = subreddit, fill = value)) + 
  # 使用 geom_tile 绘制 heatmap
  geom_tile() + 
  # 修改颜色让它更美观
  scale_fill_gradient(low = "white", high = "purple") + 
  # 去除坐标轴
  xlab("") + 
  ylab("") 
```

<details>
<summary>Click to show figure</summary>

<img src="https://raw.githubusercontent.com/leondong98/Text-Analysis-Workshop/main/images/1-2.png" width="700"/>

</details>

> “geopolitics” 子版块似乎几乎不包含与 sanctity（神圣） 相关的语言；而 “confession” 子版块则大量使用了与 sanctity 相关的词汇。
> 
> 与 care（关怀） 相关的语言在 “relationship_advice” 和 “AmItheAsshole” 子版块中则较为常见。


3. care 和 sanctity 的词典得分之间的相关性是多少？这两个道德基础是否彼此密切相关？

```r
cor(mft_texts$care_dictionary,mft_texts$sanctity_dictionary)
```

```
[1] 0.03435137
```
> 不，基于 care 与 sanctity 的语言之间的相关性非常低。



## 1.9 课后思考

（这一部分在正式授课中并不会直接提供代码，而会在相应seminar结束后的第二天更新代码和解决方案）

1. 请模仿seminar中的分析过程，将其应用到其余三个道德基础类别上：fairness、loyalty 和 authority。然后，绘制一张图表，展示每个 subreddit 在每个道德基础类别上的平均词典得分。

```r
mft_dictionary_list <- list(
  care = mft_dictionary_words$word[mft_dictionary_words$foundation == "care"],
  sanctity = mft_dictionary_words$word[mft_dictionary_words$foundation == "sanctity"],
  authority = mft_dictionary_words$word[mft_dictionary_words$foundation == "authority"],
  fairness = mft_dictionary_words$word[mft_dictionary_words$foundation == "fairness"],
  loyalty = mft_dictionary_words$word[mft_dictionary_words$foundation == "loyalty"]
  )

mft_dictionary <- dictionary(mft_dictionary_list)

mft_dfm_dictionary <- dfm_lookup(mft_dfm, mft_dictionary)

mft_dfm_dictionary_proportions <- mft_dfm_dictionary/mft_n_words

mft_texts$care_dictionary <- as.numeric(mft_dfm_dictionary_proportions[,1])
mft_texts$sanctity_dictionary <- as.numeric(mft_dfm_dictionary_proportions[,2])
mft_texts$authority_dictionary <- as.numeric(mft_dfm_dictionary_proportions[,3])
mft_texts$fairness_dictionary <- as.numeric(mft_dfm_dictionary_proportions[,4])
mft_texts$loyalty_dictionary <- as.numeric(mft_dfm_dictionary_proportions[,5])

dictionary_means_by_subreddit <- mft_texts %>%
  group_by(subreddit) %>%
  summarise(care_dictionary = mean(care_dictionary),
            sanctity_dictionary = mean(sanctity_dictionary),
            authority_dictionary = mean(authority_dictionary),
            fairness_dictionary = mean(fairness_dictionary),
            loyalty_dictionary = mean(loyalty_dictionary)) 


dictionary_means_by_subreddit %>%
  # Transform the data to "long" format for plotting
  pivot_longer(-subreddit) %>%
  # Use ggplot
  ggplot(aes(x = name, y = subreddit, fill = value)) + 
  # geom_tile creates a heatmap
  geom_tile() + 
  # change the colours to make them prettier
  scale_fill_gradient(low = "white", high = "purple") + 
  # remove the axis labels
  xlab("") + 
  ylab("") 
```
<details>
<summary>Click to show figure</summary>

<img src="https://raw.githubusercontent.com/leondong98/Text-Analysis-Workshop/main/images/1-3.png" width="700"/>

</details>








  

 




