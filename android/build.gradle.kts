allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}



// Auto set namespace cho mọi Android library plugin không khai báo namespace
subprojects {
    plugins.withId("com.android.library") {
        // Sử dụng extensions.configure để cấu hình extension một cách an toàn
        // mà không cần import. 'this' trong khối lệnh sẽ là LibraryExtension.
        extensions.configure<com.android.build.api.dsl.LibraryExtension>("android") {
            if (namespace.isNullOrBlank()) {
                val manifestFile = project.file("src/main/AndroidManifest.xml")

                if (manifestFile.exists()) {
                    val parsedManifest = groovy.xml.XmlSlurper(false, false).parse(manifestFile)
                    val packageName = parsedManifest.getProperty("@package")?.toString()

                    if (!packageName.isNullOrBlank()) {
                        namespace = packageName
                        project.logger.lifecycle("Set namespace for ${project.path} -> $packageName")
                    } else {
                        // Fallback an toàn nếu manifest không có package
                        val fallbackNamespace = "fix.${rootProject.name}.${project.name}".replace(Regex("[^A-Za-z0-9_.]"), "_")
                        namespace = fallbackNamespace
                        project.logger.lifecycle("Set fallback namespace for ${project.path} -> $fallbackNamespace")
                    }
                } else {
                    // Xử lý trường hợp không tìm thấy file Manifest
                    val fallbackNamespace = "fix.${rootProject.name}.${project.name}".replace(Regex("[^A-Za-z0-9_.]"), "_")
                    namespace = fallbackNamespace
                    project.logger.warn("AndroidManifest.xml not found for ${project.path}. Set fallback namespace -> $fallbackNamespace")
                }
            }
        }
    }
}