import { FILE_BASE_URL } from './contants.js';

/**
 * 
 * @param {*} func 原始函数
 * @param {*} wait 等待时间
 * @returns 
 */
export const debounce = (func, wait) => {
	let timeout;
	return function (...args) {
		const context = this;
		clearTimeout(timeout);
		timeout = setTimeout(() => {
			func.apply(context, args);
		}, wait);
	};
};

/**
 * 
 * @param {*} options 枚举对象
 * @param {*} value 值
 * @returns 显示文字
 */
export const handleOptionShow = (options, value) => options?.find(item => item.value === value)?.label || '';

/**
 * 
 * @param {*} fileUrl 文件路径
 * @param {*} fileName 文件名
 */
export const downloadFileFromUrl = (fileUrl, fileName = '') => {
	// 创建一个隐藏的 a 标签
	const link = document.createElement('a');
	link.href = `${FILE_BASE_URL}?fileName=${fileUrl}`;

	// 设置下载的文件名（可选）
	if (fileName) {
		link.download = fileName;
	} else {
		// 若未传入文件名，尝试从 URL 中自动解析
		const urlParts = fileUrl.split('/');
		link.download = urlParts[urlParts.length - 1];
	}

	// 触发点击
	document.body.appendChild(link);
	link.click();

	// 清理 DOM
	document.body.removeChild(link);
}
