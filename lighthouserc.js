module.exports = {
  ci: {
    collect: {
      startServerCommand: `docker run -p 8080:80 ${process.env.IMAGE}`,
      startServerReadyPattern: "start worker processes",
      url: [
        'http://localhost:8080/',
        'http://localhost:8080/posts/',
        'http://localhost:8080/posts/modeling-crdts-in-alloy-counters/',
      ]
    },
    // assert: {
    //   preset: 'lighthouse:recommended'
    // },
    upload: {
      target: 'temporary-public-storage',
    }
  },
}
