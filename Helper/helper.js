export const successResponse = (data = {}, message = 'Successful') => {
    return {
        status: true,
        data: data,
        message: message
    };
};

export const failureResponse = (error = {}, message = 'Failure') => {
    return {
        status: false,
        error: error,
        message: message
    };
};
