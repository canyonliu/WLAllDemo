// 指定要更新的对应的控制器

defineClass("JSPatchDemoViewController", {

// 添加或修改的方法（

addData: function() {

// 获取到控制器中的可变数组

var datas = self.dataArray();

datas.addObject("liuqingcan6");

datas.addObject("liuqingcan7");

datas.addObject("liuqingcan8");

datas.addObject("liuqingcan9");

// 如果添加成功会将数组中的第一个元素打印出来(这个可以根据需要进行打印)

//            console.log(datas.firstObject());

// 如果添加成功会将数组中的第一个元素打印出来

console.log(datas.lastObject());

self.table().reloadData();

}

})

