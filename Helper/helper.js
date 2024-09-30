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

export const createNotifications = (userId, title, description, link) =>{
    return{
        user_id: userId,
        title: title,
        description: description,
        link: link
}
}
