#===========================================================
# We'll use this to build the .NET Core code.
#===========================================================
FROM microsoft/dotnet:2.0-sdk AS core-build-step

#copy the code to the image
COPY ./src/ /build/

#move to the build directory
WORKDIR /build/

#restore and publish the bloody agent
RUN dotnet publish \
	--framework netcoreapp2.0 \
	/build/DoubleFreeTest.209/DoubleFreeTest.209.csproj \
    --output /out/

#===========================================================
# Now start making the image that will run on the pi
#===========================================================
FROM boondocks/resin-dotnet:resin-raspberrypi3-dotnet209

#copy the built files over to the device.
COPY --from=core-build-step /out/ /opt/test/

CMD [ "dotnet", "/opt/test/DoubleFreeTest.209.dll" ]