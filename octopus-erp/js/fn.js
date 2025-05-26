// 防抖
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

export const handleOptionShow = (options, value) => options?.find(item => item.value === value)?.label || '';