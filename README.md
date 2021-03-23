# AntHPA README

## 项目创建初始化命令

```shell
kubebuilder init --domain sigma.alipay.com --owner "The Alipay authors" --skip-go-version-check
kubebuilder create api --version v1 --group autoscalingextensions --kind AntHorizontalPodAutoscaler
```

## 项目路径

mkdir -f ${GOPATH}/src/gitlab.alipay-inc.com/sigma

## 静态代码检查工具

brew install golangci/tap/golangci-lint


## k8s代码存放路径

${GOPATH}/src/k8s.io/kubernetes

## 本地运行测试

make test

## 关于添加新包的问题

在你添加新的外部依赖包的时候请记得做2件事情

1. 在`Gopkg.toml`添加依赖
2. 设置代理命令 `export http_proxy=0.0.0.0:1087;export https_proxy=0.0.0.0:1087;export no_proxy='gitlab.alipay-inc.com,gitlab.alibaba-inc.com'`
3. 运行dep ensure -v(需要添加proxy)
4. commit代码的时候检查你的依赖包已经在vender目标下面, 并且包含在你的提交记录里面

## 参考资料

[Best Practice of Operator](https://yuque.antfin-inc.com/sys/sigma3.x/nclgfg)
[kubebuilder如何使用](https://book.kubebuilder.io/basics/what_is_a_resource.html)
[antvip参考代码](http://gitlab.alipay-inc.com/sigma/antvip-controller)

## 什么时候应该使用指针

1. 你需要函数中修改这个对象, 并且希望向外传递改修改
2. 你希望对于这个对象进行 `!=nil` 的判读, 因为对于go而言所有的对象都会被初始化

## Controller灰度
设置环境变量: `POD_AUTOSCALER_VERSION`。
Controller就只会对含有Label：`pod-autoscaler.k8s.alipay.com/version`，
且值与环境变量一致的`AntHorizontalPodAutoscaler`等生效，达到灰度发布Controller的目的。

## 测试数据相关
1. ceresdb线下测试地址  
http://10.210.178.140:5000/api/query
2. apmonitor线下测试地址 
http://11.167.138.34:8341/private_api/metric/dataQueryV2