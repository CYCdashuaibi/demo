<%@ page contentType="text/html;charset=UTF-8" %>
<%@ include file="/WEB-INF/include/taglib.jsp" %>
<html>
<head>
    <title>${fns:getConfig('productName')}</title>
    <meta name="decorator" content="blank"/>

    <script type="text/javascript">
        var serverPath = '${pageContext.request.contextPath}';
    </script>

    <!---<<<<  Vue生成  >>>>-->
    <script type="text/javascript" src="${ctxStatic}/${systemName}/lib/js/vue-2.6.11.js"></script>
    <!-- 引入样式 -->
    <link rel="stylesheet" href="${ctxStatic}/common/element-ui/css/index.css">
    <!-- 引入组件库 -->
    <script src="${ctxStatic}/common/element-ui/index.js"></script>
    <script type="text/javascript" src="${ctxStatic}/trade/js/management/dayjs.min.js"></script>
    <!-- 数据图形 -->
    <link rel="stylesheet" href="${ctxStatic}/trade/css/octopus/commission.css" />
</head>
<body>
<div id="confList" v-cloak>
    <!-- 页面内容区 -->
    <div class="viewFrame-main" id="viewFrame" v-cloak>
        <div class="fsz19 font-600 py19">推荐订单策略组列表</div>
        <div class="main-con-box">
            <div class="d-flex">
                <el-input size="small" class="mr-19" style="width:2.4rem" v-model="searchForm.taskKeyword" placeholder="请输入策略组ID/组名称">
                </el-input>
                <el-input size="small" class="mr-19" style="width:2.4rem" v-model="searchForm.oldGoodsKeyword" placeholder="请输入原商品ID/名称">
                </el-input>
                <el-input size="small" class="mr-19" style="width:2.4rem" v-model="searchForm.oldSkuKeyword" placeholder="请输入原货品ID/名称">
                </el-input>
                <el-input size="small" class="mr-19" style="width:2.4rem" v-model="searchForm.targetGoodsKeyword" placeholder="请输入现商品ID/名称">
                </el-input>
                <el-input size="small" class="mr-19" style="width:2.4rem" v-model="searchForm.targetSkuKeyword" placeholder="请输入现货品ID/名称">
                </el-input>
                <el-button type="text" size="small" @click="reset()">重置</el-button>
                <el-button type="primary" @click="getList(true)" icon="el-icon-search" size="mini">
                    搜索
                </el-button>
            </div>
            <div class="d-flex ai-center mr-19" style="margin-top: 20px;">
                <span class="mr-19">已选 {{multipleSelection.length}} 个策略</span>
                <el-button class="handle-btn" type="primary" @click="handleBatchStatus('1')"
                           size="mini" icon="el-icon-video-play"
                           plain>
                    批量启动
                </el-button>
                <el-button class="handle-btn" type="primary"
                           @click="handleBatchStatus('0')"
                           size="mini" icon="el-icon-video-pause"
                           plain>批量暂停
                </el-button>
                <el-button class="handle-btn" type="primary"  style="margin-right: 10px;" @click="toAdd" icon="el-icon-plus" size="mini">
                    新增
                </el-button>
                <el-input size="small" class="mr-19" style="width:2.4rem" v-model="merchantIdInput" placeholder="请输入分销商ID"></el-input>
                <el-button class="handle-btn" type="warning" @click="excludeMerchantAdd" size="mini" icon="el-icon-circle-plus-outline">排除分销商新增</el-button>
                <el-button class="handle-btn" type="danger" @click="excludeMerchantDelete" size="mini" icon="el-icon-delete">排除分销商删除</el-button>
            </div>
            <el-table ref="multipleTable" class="mb-2" :data="entryList" tooltip-effect="dark" style="width: 100%;margin-top: 10px;" size="mini"
                      @selection-change="handleSelectionChange" v-loading="pager.loading">
                <el-table-column type="selection" width="50">
                </el-table-column>
                <el-table-column label="策略组ID" width="60">
                    <template slot-scope="scope">{{ scope.row.groupId }}</template>
                </el-table-column>
                <el-table-column label="策略组名称">
                    <template slot-scope="scope"><el-button type="text" size="small" @click="toTaskList(scope.row)">{{ scope.row.groupName }}</el-button></template>
                </el-table-column>
                <el-table-column label="创建时间" show-overflow-tooltip>
                    <template slot-scope="scope">{{ dayjs(scope.row.createDate).format('YYYY-MM-DD HH:mm') }}</template>
                </el-table-column>
                <el-table-column label="更新时间" show-overflow-tooltip>
                    <template slot-scope="scope" v-if="scope.row.updateDate">{{ dayjs(scope.row.updateDate).format('YYYY-MM-DD HH:mm') }}</template>
                </el-table-column>
                <el-table-column label="开启状态" width="80">
                    <template slot-scope="scope">
                        <el-switch active-value="1" @change="handleSingleStatus($event,scope.row)"
                                   inactive-value="0" v-model="scope.row.valid">
                        </el-switch>
                    </template>
                </el-table-column>
                <el-table-column label="操作" width="150" show-overflow-tooltip>
                    <template slot-scope="scope">
                        <div>
                            <el-button type="text" size="small" @click="toEdit(scope.row)">编辑</el-button>
                            <el-button type="text" size="small" @click="toCopy(scope.row)">复制</el-button>
                            <el-button type="text" size="small" @click="remove(scope.$index)">删除</el-button>
                        </div>
                    </template>
                </el-table-column>
            </el-table>
            <div class="d-flex ai-center">
                <el-pagination style="margin-left: auto;" @size-change="handleSizeChange" @current-change="handleCurrentChange"
                               :current-page="pager.pageNo" :page-sizes="[10, 20, 30, 40]" :page-size="pager.pageSize"
                               layout="total, sizes, prev, pager, next, jumper" :total="pager.totalCount">
                </el-pagination>
            </div>
        </div>
    </div>
</div>
<script>
    let opUrl = ctx;
    // let opUrl = 'http://newdev2.ejcop.com:1081/octopus'

    let app = new Vue({
        el: "#viewFrame",
        data() {
            return {
                isShow: false,
                multipleSelection: [],
                searchForm: {
                    taskKeyword: "",
                    oldGoodsKeyword: "",
                    oldSkuKeyword: "",
                    targetGoodsKeyword: "",
                    targetSkuKeyword: "",
                },
                pager:{
                    pageNo: 1,
                    pageSize: 10,
                    totalCount: 0,
                    loading: false
                },
                entryList: [],
                merchantIdInput: ''
            };
        },
        created() {
            //
            initRem();
            this.getList();
        },

        methods: {
            //
            getList(isInit) {
                if(isInit){
                    this.pager.pageNo = 1;
                }
                if(this.pager.loading){
                    return;
                }
                this.pager.loading = true;
                $.ajax({
                    url: opUrl + "/trade/migrate/queryGroupList",
                    type: "post",
                    dataType: "json",
                    contentType: "application/json",
                    data: JSON.stringify({
                        pageNo: this.pager.pageNo,
                        pageSize: this.pager.pageSize,
                        ...this.checkSearchForm()
                    }),
                    success: (res) => {
                        setTimeout(() => {
                        		this.pager.loading = false;
                        }, 500)
                        if(res.code === '0000'){
                            let {count, list} = res.data;
                            this.entryList = list;
                            this.pager.totalCount = count;
                        }
                    },
                });
            },
            checkSearchForm() {
                let {taskKeyword,oldGoodsKeyword, oldSkuKeyword, targetGoodsKeyword, targetSkuKeyword} = this.searchForm;
                let result = {
                    groupId: "",
                    groupName: "",
                    oldGoodsId: "",
                    oldGoodsName: "",
                    oldSkuId: "",
                    oldSkuName: "",
                    newGoodsId: "",
                    newGoodsName: "",
                    newSkuId: "",
                    newSkuName: ""
                }
                let regex = /^[\d]*$/;
                if(taskKeyword){
                    if(regex.test(taskKeyword)){
                        result.groupId = taskKeyword;
                    }else{
                        result.groupName = taskKeyword;
                    }
                }
                if(oldGoodsKeyword){
                    if(regex.test(oldGoodsKeyword)){
                        result.oldGoodsId = oldGoodsKeyword;
                    }else{
                        result.oldGoodsName = oldGoodsKeyword;
                    }
                }
                if(oldSkuKeyword){
                    if(regex.test(oldSkuKeyword)){
                        result.oldSkuId = oldSkuKeyword;
                    }else{
                        result.oldSkuName = oldSkuKeyword;
                    }
                }
                if(targetGoodsKeyword){
                    if(regex.test(targetGoodsKeyword)){
                        result.newGoodsId = targetGoodsKeyword;
                    }else{
                        result.newGoodsName = targetGoodsKeyword;
                    }
                }
                if(targetSkuKeyword){
                    if(regex.test(targetSkuKeyword)){
                        result.newSkuId = targetSkuKeyword;
                    }else{
                        result.newSkuName = targetSkuKeyword;
                    }
                }
                return result;
            },
            reset() {
                this.searchForm =  {
                    taskKeyword: "",
                    oldGoodsKeyword: "",
                    oldSkuKeyword: "",
                    targetGoodsKeyword: "",
                    targetSkuKeyword: "",
                }
                this.getList(true);
            },
            handleSelectionChange(val) {
                this.multipleSelection = val;
            },
            handleSizeChange(val) {
                this.pager.pageSize = val;
                this.getList();
            },
            handleCurrentChange(val) {
                this.pager.pageNo = val;
                this.getList();
            },
            remove(index) {
                this.$confirm('确定删除该策略组？<br/>该操作将删除该策略组下的所有策略，请谨慎操作！', '温馨提示', {
                    confirmButtonText: '确定',
                    cancelButtonText: '取消',
                    type: 'warning',
                    dangerouslyUseHTMLString: true
                }).then(() => {
                    let item = this.entryList[index];
                    $.ajax({
                        url: opUrl + "/trade/migrate/delTaskGroup",
                        type: "post",
                        dataType: "json",
                        contentType: "application/json",
                        data: JSON.stringify({
                            groupId: item.groupId
                        }),
                        success: (res) => {
                            this.isHandling = false;
                            if(res.code === '0000'){
                                this.entryList.splice(index,1);
                                this.$message({
                                    message: '删除成功',
                                    type: 'success'
                                });
                            }else{
                                this.$message.error('删除失败');
                            }
                        },
                    });
                }).catch(() => {

                });
            },
            handleStatus(list,type) {
                if(!list.length){
                    return;
                }
                let targetList = list.map((item) => {
                    return item.groupId;
                });
                let params = {
                    "groupIds": targetList,
                    "valid": type
                }
                $.ajax({
                    url: opUrl + "/trade/migrate/updateGroupValid",
                    type: "post",
                    dataType: "json",
                    contentType: "application/json",
                    data: JSON.stringify(params),
                    success: (res) => {
                        this.isHandling = false;
                        if(res.code === '0000'){
                            list.forEach((item) => {
                                item.valid = type;
                            })
                            this.$message({
                                message: type ? "开启成功" : "暂停成功",
                                type: 'success'
                            });
                        }else{
                            this.$message.error('操作失败');
                        }
                    },
                });
            },
            handleSingleStatus(flag, item) {
                this.handleStatus([item], flag);
            },
            handleBatchStatus(type) {
                if(!this.multipleSelection.length){
                    this.$message({
                        message: "请先选择策略组！",
                        type: 'warning'
                    });
                }
                this.handleStatus(this.multipleSelection, type);
            },
            toAdd() {
                window.open("./groupEdit")
            },
            toTaskList(item) {
                window.open("./list?groupId="+item.groupId)
            },
            toEdit(item) {
                window.open("./groupEdit?groupId="+item.groupId)
            },
            toCopy(item) {
            	window.open("./groupEdit?groupId="+item.groupId+"&pageType=copy")
            },
            excludeMerchantAdd() {
                if (!this.merchantIdInput.trim()) {
                    this.$message.error('请填写分销商ID');
                    return;
                }
                if (!this.multipleSelection || this.multipleSelection.length === 0) {
                    this.$message.error('请选择至少一个策略组');
                    return;
                }

                this.isHandling = true;

                const groupIdList = this.multipleSelection.map(item => item.groupId);
                const payload = {
                    groupIdList: groupIdList,
                    merchantId: parseInt(this.merchantIdInput, 10),
                };

                $.ajax({
                    url: opUrl + "/trade/migrate/batchSaveMerchantIds",
                    type: "post",
                    dataType: "json",
                    contentType: "application/json",
                    data: JSON.stringify(payload),
                    success: (res) => {
                        console.log("Received data:", res);
                        this.isHandling = false;
                        if (res.code === '0000') {
                            this.$message({
                                message: "排除分销商新增成功",
                                type: 'success'
                            });
                        } else {
                            this.$message.error('排除分销商新增失败');
                        }
                    }
                });
            },

            excludeMerchantDelete() {
                if (!this.merchantIdInput.trim()) {
                    this.$message.error('请填写分销商ID');
                    return;
                }
                if (!this.multipleSelection || this.multipleSelection.length === 0) {
                    this.$message.error('请选择至少一个策略组');
                    return;
                }

                this.isHandling = true;

                const groupIdList = this.multipleSelection.map(item => item.groupId);
                const payload = {
                    groupIdList: groupIdList,
                    merchantId: parseInt(this.merchantIdInput, 10),
                };

                $.ajax({
                    url: opUrl + "/trade/migrate/batchDeleteMerchantIds",
                    type: "post",
                    dataType: "json",
                    contentType: "application/json",
                    data: JSON.stringify(payload),
                    success: (res) => {
                        console.log("Received data:", res);
                        this.isHandling = false;
                        if (res.code === '0000') {
                            this.$message({
                                message: "排除分销商删除成功",
                                type: 'success'
                            });
                        } else {
                            this.$message.error('排除分销商删除失败');
                        }
                    }
                });
            }
        },
    });

    function initRem() {
        var tid;

        function refreshRem() {
            let designSize = 1920; // 设计图尺寸
            let html = document.documentElement;
            let wW = html.clientWidth; // 窗口宽度
            let rem = (wW * 100) / designSize;
            document.documentElement.style.fontSize = rem + "px";
        }

        window.addEventListener(
            "resize",
            function () {
                clearTimeout(tid);
                tid = setTimeout(refreshRem, 200);
            },
            false
        );
        window.addEventListener(
            "pageshow",
            function (e) {
                if (e.persisted) {
                    clearTimeout(tid);
                    tid = setTimeout(refreshRem, 200);
                }
            },
            false
        );

        refreshRem();
    }
</script>
</body>
</html>