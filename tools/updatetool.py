import json

with open ('./icons.json', 'r') as f:
    icons = json.load(f)

classes = []
codes = []

for name, atts in icons.items():
    if "solid" in atts['styles']:
        iconClass =  (name.title().replace(' ', '').replace('-',''))
        iconCode = r'"\u{%s}"' % atts['unicode']

        classes.append("FA%s" %iconClass)
        codes.append(iconCode)

	
print "case " + ", ".join(classes)
print "private let FAIcons = [%s]" %( ", ".join(codes))
    
	#echo "Classes:<br>case $classes<br><br>Unicode:<br>private let FAIcons = [$codes]<br><br>Helper:<br>let helper = [\"$classStrings\"]";

