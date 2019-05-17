---
title: "sample"
date: 2019-05-14
draft: true
---

#高亮代码和显示代码行数

{{< highlight CSharp "linenos=table, hl_lines=1 2 9-17,linenostart=199" >}}

[Option(ShortName = "l", LongName = "eighteen", ShowInHelpText = true, Description = "18位身份证号")]
public bool Long { get; set; }

[Option("-s|--fifteen", Description = "15位身份证号")]
public bool Short { get; set; }

public void OnExecute(IConsole console)
{
        console.WriteLine(StartWith);
        if (Long)
	{
		console.WriteLine(genId());
	}
	else if (Short)
	{
		console.WriteLine("Short");
	}
}

{{< / highlight >}}


{{< ruby rb="深表悲痛" rt="Xi Wen Le Jian" >}}

 {{< ruby rb="My heart is broken." rt="I'm happy for that." >}}