function irekiIndex(){
	ipFiltratugabe=$(ip addr | grep -E "inet .*brd")
	ipIaFiltratua=$(echo ${e:9:50})
	ip=$(echo $ipIaFiltratua | cut -d"/" -f1)
	

	firefox "$ip"/index.html
}