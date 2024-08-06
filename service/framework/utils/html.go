/**
#*****************************************************************************
# @author  MakerYang
# @site    mir2.makeryang.com
#*****************************************************************************
*/

package Utils

import (
	"github.com/russross/blackfriday"
	"regexp"
	"strings"
)

func TrimHtml(html string) string {
	//将HTML标签全转换成小写
	re, _ := regexp.Compile("<[\\S\\s]+?>")
	html = re.ReplaceAllStringFunc(html, strings.ToLower)
	//去除STYLE
	re, _ = regexp.Compile("<style[\\S\\s]+?</style>")
	html = re.ReplaceAllString(html, "")
	//去除SCRIPT
	re, _ = regexp.Compile("<script[\\S\\s]+?</script>")
	html = re.ReplaceAllString(html, "")
	//去除所有尖括号内的HTML代码，并换成换行符
	re, _ = regexp.Compile("<[\\S\\s]+?>")
	html = re.ReplaceAllString(html, "\n")
	//去除连续的换行符
	re, _ = regexp.Compile("\\s{2,}")
	html = re.ReplaceAllString(html, "\n")
	return strings.TrimSpace(html)
}

func Markdown2Html(markdown string) string {
	html := blackfriday.MarkdownCommon([]byte(markdown))
	return string(html)
}
