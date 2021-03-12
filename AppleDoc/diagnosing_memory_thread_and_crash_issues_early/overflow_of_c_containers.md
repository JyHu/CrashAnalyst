# C ++容器溢出

[Overflow of C++ Containers](https://developer.apple.com/documentation/xcode/diagnosing_memory_thread_and_crash_issues_early/overflow_of_c_containers)

检测何时超出其范围访问C ++容器。

---

## 总览

此检查检测何时访问了区域之外的libc ++容器-即使所访问的内存在容器内部使用的堆分配的缓冲区中。`[container.begin(), container.end())`

> **注意**
> 默认情况下，此检查是禁用的，因为它要求使用的所有静态链接库都在启用Address Sanitizer的情况下构建。若要启用此检查，请将“为地址清理器生成启用C ++容器溢出检查”设置设置为。`std::vector``YES`

### C ++中的向量溢出

在下面的示例中，该`vector`变量的有效索引在range内`[0, 2]`，但在index处进行访问`3`，从而导致溢出。

```
std::vector<int> vector;
vector.push_back(0);
vector.push_back(1);
vector.push_back(2);
auto *pointer = &vector[0];
return pointer[3]; // Error: out of bounds access for vector
```

#### 解

在尝试访问索引处的容器之前，请添加边界检查。