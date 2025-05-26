// let opUrl = ctx;

// export const opUrl = "http://newdev2.ejcop.com:1081/octopus";
export const opUrl = "/api";
export const FILE_BASE_URL = '/product/chummyDistributor/getFile';

export const VIEW_SCENE = {
    ADD: '新增合同',
    VIEW: "合同详情",
    AUDIT: "合同审核",
};

export const SUCCESS_CODE = '00000000';

// 合同类型
export const CONTRACT_TYPE_OPTIONS = [
    { value: '1', label: '直客运营商' },
    { value: '2', label: '代理供应商-号卡' },
    { value: '3', label: '代理供应商-存量' },
    { value: '4', label: '代理供应商-宽带' },
    { value: '5', label: '物联网' },
    { value: '6', label: '媒体供应商' },
];

// 合同状态
export const CONTRACT_STATUS_OPTIONS = [
    { value: '0', label: '待审核' },
    { value: '1', label: '待归档' },
    { value: '2', label: '已归档' },
    { value: '3', label: '审核不通过' },
];

// 合同来源
export const CONTRACT_SOURCE_OPTIONS = [
    { value: '1', label: '标准合同' },
    { value: '2', label: '客户合同' },
];
