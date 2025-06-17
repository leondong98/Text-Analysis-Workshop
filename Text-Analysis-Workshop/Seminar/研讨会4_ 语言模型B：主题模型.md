---
title: '研讨会4: 语言模型B：主题模型'

---

# 研讨会4: 语言模型B：主题模型

讲座人：Hanxu hanxu.dong.21@ucl.ac.uk

<p>
  <a href="https://github.com/leondong98/Text-Analysis-Workshop/blob/main/Data/immig_thoughts.csv" 
     style="display:inline-block; background-color:#4CAF50; color:white; padding:10px 20px; text-decoration:none; margin-right:10px; border-radius:5px;">
    Seminar data
  </a>
</p>


## 4.1 焦虑对于移民态度有什么影响？

[Gadarian 和 Albertson（2013）](https://onlinelibrary.wiley.com/doi/abs/10.1111/pops.12034)探讨了负面情绪如何影响政治行为与态度。他们进行了一项实验，通过引发受访者对移民的焦虑情绪，来研究其对政治反应的影响。

为了唤起对移民的焦虑，实验组的受访者阅读了如下提示语：
>“现在，请花一点时间思考美国关于移民的辩论。当你想到‘移民’时，什么事情会让你感到担忧？请列出你想到的所有内容。”

相对地，对照组受访者则被要求根据以下提示列出自己的想法：

>“首先，请花一点时间思考美国关于移民的辩论。当你想到‘移民’时，你会想到什么？请列出你想到的所有内容。”

两个组的受访者都被提供了文本框，供其写下自己的想法。

我们研究的目标是：分析这些文本内容，判断焦虑诱导提示是否会导致受访者提供的回答在系统性上与普通提示的回答存在差异。


## 4.2 Packages
在开始研讨会时，先下载/加载以下 R 包：

```r
library(stm)
library(tidyverse)
library(quanteda)
# 如果无法加载这些库，请先尝试安装。例如：
# install.packages("stm")  
```

## 4.3 数据集

数据文件 `immig_thoughts.csv` 包含两个变量：

| 变量名 | 描述 |
|--------------------|---------------------|
| `treat`            | 表示受访者是否属于处理组（"worried"）或对照组（"think"）的变量 |
| `response`         | 受访者根据提示语所写下的文本内容 |


一旦你下载了这个文件并将其保存在一个合适的位置，你可以使用以下命令将其加载到 R 中：

```r
immig_thoughts <- read_csv("immig_thoughts.csv")
```

使用 ``tidyverse`` 包中的 ``glimpse()`` 函数快速查看数据中的变量：
                 
```r
glimpse(immig_thoughts)
```
```
Rows: 352
Columns: 2
$ response <chr> "problems caused by the influx of illegal immigrants who are crowding our schools a…
$ treat    <chr> "worried", "worried", "think", "think", "worried", "worried", "worried", "worried",…        
```

## 4.4 STM

我们将首先实现结构主题模型的空模型。该模型等同于相关主题模型（Correlated Topic Model）--是我们在讲座中介绍过的 LDA 模型的近亲，不过在该模型中，允许语料库中的主题彼此相关（LDA 假设主题互不相关）。

你可以使用 ``stm`` 软件包中的 ``stm()`` 函数来拟合模型。你需要为该函数指定几个不同的参数：

| 参数名        | 描述说明                                                                 |
|---------------|--------------------------------------------------------------------------|
| `documents`   | 拟用于拟合 STM 模型的文档特征矩阵（DFM）                                |
| `K`           | 你希望估计的主题数量                                                     |
| `prevalence`  | 一个不包含响应变量的公式，用于指定你希望用于建模文档中主题分布的协变量 |
| `content`     | 一个不包含响应变量的公式，用于指定你希望用于建模每个主题内容的协变量   |
| `seed`        | 一个种子数，用于使结果具有可重复性                                       |

1. 从 ``immig_thoughts`` 数据中创建一个语料库。然后创建一个 DFM，并做出一些特征选择决策

<details>
<summary>Reveal Code</summary>
 
```r
# 创建一个corpus
immig_thoughts_corpus <- immig_thoughts %>%
  corpus(text_field = "response")

# 创建 dfm
# 先处理文本数据，构建 tokens 对象并移除停用词
immig_tokens <- immig_thoughts_corpus %>%
  tokens(remove_punct = TRUE) %>%
  tokens_remove(stopwords("en"))

# 构建 dfm
immig_thoughts_dfm <- dfm(immig_tokens)
``` 
    
</details>  


2. 使用 ``stm`` 包中的 ``stm()`` 函数拟合一个主题模型。你需要选择一个合适的主题数量（K）

<details>
<summary>Reveal Code</summary>
 
```r
stm_out <- stm(immig_thoughts_dfm,
                 K = 10,
                 prevalence = ~treat, 
                 verbose = FALSE) # verbose = FALSE 可以阻止 stm() 在模型估计过程中打印更新信息（例如迭代进度），使控制台输出保持干净
``` 

```r
save(stm_out, file = "stm_out.Rdata")
``` 
    
</details>  
    
3. 使用 plot() 函数评估每个主题在该语料库中的常见程度。最常见的主题是什么？最不常见的是什么？

<details>
<summary>Reveal Code</summary>
  
```r
plot(stm_out)
```   
    
<img src="https://raw.githubusercontent.com/leondong98/Text-Analysis-Workshop/main/images/4_7.png" width="700"/>
    
</details>  
    
 
4. 使用 labelTopics() 函数提取每个主题中最具代表性的词语。对这些主题“标签”进行一些解释。（注意，stm 包为加权词语在估计的主题模型中提供了各种不同的度量方法。对我们来说最相关的两个是 Highest Prob 和 FREX。Highest Prob 简单地报告在每个主题中具有最高概率的词（即直接从参数推断得出）。FREX 是一种结合了频率和排他性的加权方法（当一个词在某一主题中常见但在其他主题中不常见时，其权重会上升））

<details>
<summary>Reveal Code</summary>
      
    
```r
# 查看前十个主题
labelTopics(stm_out)
``` 

```
Topic 1 Top Words:
 	 Highest Prob: think, country, coming, legally, need, immigration, people 
 	 FREX: coming, think, legally, country, everyone, becoming, entering 
 	 Lift: accidents, actively, adapting, alien, allegiance, american's, americas 
 	 Score: think, coming, history, citizen, entering, receive, need 
Topic 2 Top Words:
 	 Highest Prob: jobs, americans, security, crime, social, illegals, take 
 	 FREX: crime, social, jobs, security, americans, healthcare, cost 
 	 Lift: crime, accountability, activity, altime, amercia, amounts, anxious 
 	 Score: jobs, cost, social, security, crime, lost, healthcare 
Topic 3 Top Words:
 	 Highest Prob: border, people, mexicans, citizens, mexico, immigrants, country 
 	 FREX: mexicans, wall, fences, border, political, rate, another 
 	 Lift: 18, 95, abroad, access, across, although, arizona 
 	 Score: mexicans, fences, another, political, consider, future, mostly 
Topic 4 Top Words:
 	 Highest Prob: immigrants, illegal, services, laws, paid, aliens, paying 
 	 FREX: immigrants, paid, services, losing, aliens, laws, illegal 
 	 Lift: abolition, accomplish, activities, allour, allowing, ancestors, assumption 
 	 Score: paid, laws, congress, failure, kicked, lobbyists, seem 
Topic 5 Top Words:
 	 Highest Prob: people, work, legal, think, us, immigrants, come 
 	 FREX: work, difficult, process, like, legal, $, freedoms 
 	 Lift: =, $, 125, 600, adjust, afford, agree 
 	 Score: process, $, vs, even, think, freedoms, difficult 
Topic 6 Top Words:
 	 Highest Prob: taxes, english, pay, people, better, jobs, life 
 	 FREX: taxes, nothing, better, pay, one, worried, make 
 	 Lift: agreed, alcohol, ancious, attention, blood, breed, child 
 	 Score: taxes, nothing, pay, worried, make, one, families 
Topic 7 Top Words:
 	 Highest Prob: poor, immigrants, system, care, health, legal, english 
 	 FREX: poor, system, terrorists, criminals, build, communities, contribute 
 	 Lift: #1, accross, americanized, annoying, anymore, asians, barriers 
 	 Score: poor, wanting, causing, dobbs, last, lou, grandparents 
Topic 8 Top Words:
 	 Highest Prob: people, immigrants, many, language, states, worry, come 
 	 FREX: states, united, things, worry, able, language, many 
 	 Lift: 11, 12, 9, abused, accomodated, accomodating, actually 
 	 Score: assimilate, things, pay, states, united, resources, language 
Topic 9 Top Words:
 	 Highest Prob: immigration, workers, economy, usa, worry, nation, concerns 
 	 FREX: concerns, state, workers, economy, bad, potential, usa 
 	 Lift: affects, afraid, along, alter, alternative, among, bad 
 	 Score: state, concerns, nation, workers, economy, capitalist, painting 
Topic 10 Top Words:
 	 Highest Prob: people, illegal, immigration, us, taking, schools, dont 
 	 FREX: dont, hospitals, strain, schools, taking, us, problems 
 	 Lift: aboration, abuses, allowed, anymore.and, arent, assilum, assistance 
 	 Score: us, im, taking, dont, stop, hospitals, problems
``` 
    
</details> 
    

5. 使用 `cloud()` 函数为两个最有趣的主题创建词云图

<details>
<summary>Reveal Code</summary>
    
```r
cloud(stm_out, 3)
```
    
<img src="https://raw.githubusercontent.com/leondong98/Text-Analysis-Workshop/main/images/4_9.png" width="700"/>    
    
    
```r
cloud(stm_out, 6)
```
    
<img src="https://raw.githubusercontent.com/leondong98/Text-Analysis-Workshop/main/images/4_8.png" width="700"/>
    
</details> 
    
6. 使用 `stm` 包中的 `findThoughts()` 函数，从模型中找出最能代表每个主题的原始文本，你发现了什么？
    
<details>
<summary>Reveal Code</summary>
 
```r
findThoughts(stm_out, 
             texts = immig_thoughts$response,
             topics = 1:10,
             n = 1)
``` 
    
```
Topic 1: 
 	 when i think of immigration i think of people who enter this country legally, who go through the proper immigration process, no matter how long it takes.  i think of people who are willing to learn the english language, make an honest living, honor our country and pledge allegiance to our flag.  those who come to america by any other means, who sneak in here and file false paperwork, who think they have the right to drive and have a license, who manage to obtain false ssn's don't deserve to be here, and our borders need to be much, much more secure. 
 Topic 2: 
 	 legally entering the usa meeting the requirements is the law. entering the usa improperly is a crime. it is unfortunate that the american bar association has fought treating entering the usa as a crime. and our politicians from both parties have been so anxious to get the "vote" that they refuse to inforce the law. meanwhile, terorists can walk right in without any problem. no accountability on the part of politicians supported by the news media will bring our nation down eventually. and the normal person will wonder how it happened. 
 Topic 3: 
 	 as an arizona resident who lives 18 miles from the mexican-us border, and who has also spoken to some of these illegals while hiking in the huachuca mtns., i know these people, mostly, come here out of sheer desperation.  sure, some are the same lazy, fat, undereducated jerks that lurk around our own mid-level businesses.  but most simply are people who want what we all do: a comfortable life with as little thinking and suffering as possible, while reproducing at will.  they have told me, babies in arms,that if they remain at home, they have no future but an early death.  that they, maybe, should reduce their birth rate and/or not have children at all, if they cannot support them, simply will never occur to citizens of a catholic country, living a day's walk from a rich country that can be easily milked for what they consider a fortune in life support.  there is no answer to this, so long as 95% of mexico's wealth is controlled by 5% of its people, and the only riches the others have lie in their children. 
 Topic 4: 
 	 i firmly believe that the u.s. is a melting pot of nationalities and races -- people of different ethnic backgrounds blending into one rich culture - without losing the distinctiveness of their own culture.  in order to accomplish this safely and effectively:  1)immigrants must be in our country legally  2)immigrants need to learn our language  3) immigrants need to obey our laws. fears about illegal immigrants: terrorism, criminal activities, heavy drain on social services & medical services, weighing down the public school systems esl & other special needs. 
 Topic 5: 
 	 i think of the american born people, and how we've sacrificed to give them their freedom. i think a lot of people have becom frustrated with it all. when white people apply for a job (minimum wage) and they are told their salary is not negotiable, and yet the minority is able to negotiate a higher wage for the same job. it is discrimination against our own. i think of what andy rooney said a while ago about this very subject and agree completely. if you come to our country - speak english. respect our laws. our country doesn't owe you anything, work for it like the rest of us! simply, i am against illegal immigrants, and legal immigrants should adjust to our ways, not us - to theirs. 
 Topic 6: 
 	 what really makes me worried is that we are doing nothing to fix the system i agreed that we need to pay attention to our borders but at the same time there is people hard working people that are here illegaly and they are ancious to obtain some king of work permit so they can work legally, they did cross the border ok make them pay a fine of course criminals they must be deported 
 Topic 7: 
 	 poor people wanting a better life because their own country is so full of 
corruption. they have found it too easy to slip accross the border and our government must have some reasons for wanting them here to keep our wages lower. it has kept pur young from summer jobs. they are a major drain on 
our health care system as well as all the welfare that many get. i don't what the answer is to fixing the problem with the ones already here but amnesty as it was done the last time is not the answer either. i personally helped 3 women get their papers the last time and as far as i know only 1 became a citizen. i beleive they should all speak english and we shouldn't have to pay extra so they can learn. it should not be our job t learn spanish. 
 Topic 8: 
 	 i am enthusiastic about legal immigrants willing to assimilate and be productive members of american society.

i worry that illegal immigrants have no incentive, and often no desire to assimilate.

i worry that illegal immigrants are disproportionally involved in violent crimes, as well as drug and property crimes.

i worry that our culture and language may be diminished by those not willing to assimilate.

i worry that that our our society devotes more and more of it's resources providing health care, education and other services to those not willing to assimilate.

i worry that our careless attitude about enforcing our border and immigration policy will lead to another 9/11 style terrorist attack. 
 Topic 9: 
 	 i am most worried about the conception that forms in the relation of the modern nation state to that of the foreigner.  a relation of same and other is established that marginalizes the other in such a way as to turn hospitality into slavery.  the largest worries of immigration manifest themselves as concerns over economic effects primarily because the nation state has communally devolved into a neoliberal capitalist organization.  it is the corporisation of the state that governs the question of immigration, the question that is then framed in terms of resources and production.  my worry is that capitalist democracy will continue to perpetuate itself and replace community with individualism, consumerism, and the great american freedom-the freedom to buy 
 Topic 10: 
 	 close borders.
fine employers who employ illegal immigrats (im).
remove children of im from public schools.
no ssa or welfare for ims.
when picked up by police or any other government institution, they should be taken into custody and deported.
if an im is deported and returns to the us, they should be jailed and the family or mexican government made to paid for the cost of upkeep.
```
    
> 这里有一些证据表明，我们确实捕捉到了与不同政治立场相关的有意义的主题，围绕移民问题。例如，似乎存在关于暴力的主题（主题10）；来自墨西哥的工人（主题4）；税收（主题3）；犯罪、医院和社会保障（主题5）；等等。

> 总体而言，这里的重点是：这只是一种可能的文本表示方式，是否合理取决于主观判断。我们可以看到一些主题之间存在重复的证据——也就是说，虽然这些主题大多是连贯的，但它们可能不够“互斥”，因此也许更合理的做法是估计更少数量的主题。当然，如果我们这么做，在下一步中我们所估计的处理效应也会随之不同！
    
</details>  
    
    
7. 现在让我们来考虑一下实验组与对照组的区别，估计 `treat` 对于我们之前讨论的各个主题的影响，在实验中“唤起对移民的焦虑”的提示语是否产生了影响？其影响是否显著地不同于零？
    
<details>
<summary>Reveal Code</summary>
 
```r
# 估计处理效应
stm_effects <- estimateEffect(~treat,
                              stm_out,
                              metadata = docvars(immig_thoughts_dfm))

plot.estimateEffect(stm_effects,
                    model = stm_out,
                    covariate = "treat",           # 要绘制效应的协变量
                    topics = 1:10,                 # 要绘制的主题编号
                    method = "difference",         # 绘制处理组与对照组之间的差异
                    cov.value1 = "worried",        # 处理组（感到担忧）
                    cov.value2 = "think",          # 对照组（一般思考）
                    labeltype = "frex",            # 使用 FREX 标签来标记主题
                    n = 3,                         # 每个主题用于标记的关键词数量
                    xlim = c(-.3,.2),              # x 轴的范围限制
                    verbose.labels = FALSE)        # 去除标签中不必要的信息
``` 
               
<img src="https://raw.githubusercontent.com/leondong98/Text-Analysis-Workshop/main/images/4_10.png" width="700"/>

> 对于其中一些主题，有显著的处理效应证据！治疗组的受访者更多地谈到了暴力、对美国就业的威胁，以及犯罪与税收相关内容。而对照组的受访者则更多谈到了墨西哥工人和医疗的话题。

</details>  
    
    
8. 为了估计处理效应，你必须做出一系列可能会对你的估计结果产生影响的决策。现在请思考：在刚才的一系列问题中，你做了哪些决策？你做这些决策时有没有一些原则性的理由？

请尝试在做出不同决策的情况下重复你的分析（例如：改变主题模型中的主题数量 $K$；使用不同的特征选择方式；选择不同的训练文档，等等）。这些改变对你最终的估计结果有什么影响？这对我们使用定量文本分析方法进行因果推断所面临的挑战说明了什么？
    
<details>
<summary>Reveal Code</summary>

> 请注意：即使已经选定使用结构化主题模型（STM），我仍然可以做出其他选择——例如，我可能会做出不同的特征选择决策，或者选择不同的主题数量 $K$ ，等等
> 让我们尝试改变主题数量，看看这会对估计的处理效应产生什么影响

    
```r
library(stm)

# 估计结构化主题模型（STM）
stm_out_new <- stm(immig_thoughts_dfm,
                   K = 15,                         # 设置主题数量为 15
                   prevalence = ~treat,            # 指定协变量，用于建模主题的分布（此处为处理变量 treat）
                   verbose = FALSE)                # verbose = FALSE 可以防止 stm 打印模型估计过程中的更新信息

# 估计处理效应
stm_effects_new <- estimateEffect(~treat,
                                  stm_out_new,
                                  metadata = docvars(immig_thoughts_dfm))

plot.estimateEffect(stm_effects,
                    model = stm_out_new,
                    covariate = "treat",           # 指定我们想要绘图的协变量
                    topics = 1:10,                 # 要绘制的主题编号（前 10 个）
                    method = "difference",         # 绘制处理组与对照组之间的差异
                    cov.value1 = "worried",        # 处理组标签
                    cov.value2 = "think",          # 对照组标签
                    labeltype = "frex",            # 主题标签类型（frex 标签结合频率与排他性）
                    n = 3,                         # 每个主题标签使用的关键词数量
                    xlim = c(-.3,.2),              # 设置 x 轴范围
                    verbose.labels = FALSE)        # 不显示冗余的标签信息  
```
    
<img src="https://raw.githubusercontent.com/leondong98/Text-Analysis-Workshop/main/images/4_11.png" width="700"/>
    
> 结果是相似的，但也存在一些明显的变化。特别是，现在我们有了一个更明确呈现为“安全-医院”主题的内容，它在治疗组中被更多地使用；还有一个“真相-交易”主题，在对照组中被更多地使用。

>这里最关键的一点是：不同的文本表示方式可能导致非常不同的处理效应结果。
因此，在文本分析中，尤其是在使用基于文本的结果变量进行因果推断分析时，我们必须充分意识到这个问题！

</details> 